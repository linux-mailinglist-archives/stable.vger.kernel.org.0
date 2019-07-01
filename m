Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842D84D76A
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbfFTSPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729679AbfFTSPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:15:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0AD12082C;
        Thu, 20 Jun 2019 18:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054551;
        bh=tH79aWWsmanF5GUNCA6FAjqGhEh0z6U3AmT5MTs9gnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyOpskIr5kENJQotIypi8okLr+KoSODdRyOvyLWM/nGp3KnnA7R3hCxVu30+5/WE8
         vWv1J0D+WgbqnxiqiDmbxkTIcyG8tALzM7EiaH3tXQbKhDrFFRWQ3S+qFrwlEb4Cay
         FnI1Cd+cv6xkUE1zZwujq1HBOfZSHeUhhcl0ZWGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 67/98] s390/zcrypt: Fix wrong dispatching for control domain CPRBs
Date:   Thu, 20 Jun 2019 19:57:34 +0200
Message-Id: <20190620174352.512754228@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7379e652797c0b9b5f6caea1576f2dff9ce6a708 ]

The zcrypt device driver does not handle CPRBs which address
a control domain correctly. This fix introduces a workaround:
The domain field of the request CPRB is checked if there is
a valid domain value in there. If this is true and the value
is a control only domain (a domain which is enabled in the
crypto config ADM mask but disabled in the AQM mask) the
CPRB is forwarded to the default usage domain. If there is
no default domain, the request is rejected with an ENODEV.

This fix is important for maintaining crypto adapters. For
example one LPAR can use a crypto adapter domain ('Control
and Usage') but another LPAR needs to be able to maintain
this adapter domain ('Control'). Scenarios like this did
not work properly and the patch enables this.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/ap.h       |  4 ++--
 drivers/s390/crypto/ap_bus.c     | 26 ++++++++++++++++++++++----
 drivers/s390/crypto/ap_bus.h     |  3 +++
 drivers/s390/crypto/zcrypt_api.c | 17 ++++++++++++++---
 4 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/ap.h b/arch/s390/include/asm/ap.h
index e94a0a28b5eb..aea32dda3d14 100644
--- a/arch/s390/include/asm/ap.h
+++ b/arch/s390/include/asm/ap.h
@@ -160,8 +160,8 @@ struct ap_config_info {
 	unsigned char Nd;		/* max # of Domains - 1 */
 	unsigned char _reserved3[10];
 	unsigned int apm[8];		/* AP ID mask */
-	unsigned int aqm[8];		/* AP queue mask */
-	unsigned int adm[8];		/* AP domain mask */
+	unsigned int aqm[8];		/* AP (usage) queue mask */
+	unsigned int adm[8];		/* AP (control) domain mask */
 	unsigned char _reserved4[16];
 } __aligned(8);
 
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 1546389d71db..6717536a633c 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -254,19 +254,37 @@ static inline int ap_test_config_card_id(unsigned int id)
 }
 
 /*
- * ap_test_config_domain(): Test, whether an AP usage domain is configured.
+ * ap_test_config_usage_domain(): Test, whether an AP usage domain
+ * is configured.
  * @domain AP usage domain ID
  *
  * Returns 0 if the usage domain is not configured
  *	   1 if the usage domain is configured or
  *	     if the configuration information is not available
  */
-static inline int ap_test_config_domain(unsigned int domain)
+int ap_test_config_usage_domain(unsigned int domain)
 {
 	if (!ap_configuration)	/* QCI not supported */
 		return domain < 16;
 	return ap_test_config(ap_configuration->aqm, domain);
 }
+EXPORT_SYMBOL(ap_test_config_usage_domain);
+
+/*
+ * ap_test_config_ctrl_domain(): Test, whether an AP control domain
+ * is configured.
+ * @domain AP control domain ID
+ *
+ * Returns 1 if the control domain is configured
+ *	   0 in all other cases
+ */
+int ap_test_config_ctrl_domain(unsigned int domain)
+{
+	if (!ap_configuration)	/* QCI not supported */
+		return 0;
+	return ap_test_config(ap_configuration->adm, domain);
+}
+EXPORT_SYMBOL(ap_test_config_ctrl_domain);
 
 /**
  * ap_query_queue(): Check if an AP queue is available.
@@ -1267,7 +1285,7 @@ static void ap_select_domain(void)
 	best_domain = -1;
 	max_count = 0;
 	for (i = 0; i < AP_DOMAINS; i++) {
-		if (!ap_test_config_domain(i) ||
+		if (!ap_test_config_usage_domain(i) ||
 		    !test_bit_inv(i, ap_perms.aqm))
 			continue;
 		count = 0;
@@ -1442,7 +1460,7 @@ static void _ap_scan_bus_adapter(int id)
 				      (void *)(long) qid,
 				      __match_queue_device_with_qid);
 		aq = dev ? to_ap_queue(dev) : NULL;
-		if (!ap_test_config_domain(dom)) {
+		if (!ap_test_config_usage_domain(dom)) {
 			if (dev) {
 				/* Queue device exists but has been
 				 * removed from configuration.
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 15a98a673c5c..6f3cf37776ca 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -251,6 +251,9 @@ void ap_wait(enum ap_wait wait);
 void ap_request_timeout(struct timer_list *t);
 void ap_bus_force_rescan(void);
 
+int ap_test_config_usage_domain(unsigned int domain);
+int ap_test_config_ctrl_domain(unsigned int domain);
+
 void ap_queue_init_reply(struct ap_queue *aq, struct ap_message *ap_msg);
 struct ap_queue *ap_queue_create(ap_qid_t qid, int device_type);
 void ap_queue_prepare_remove(struct ap_queue *aq);
diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index c31b2d31cd83..03b1853464db 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -822,7 +822,7 @@ static long _zcrypt_send_cprb(struct ap_perms *perms,
 	struct ap_message ap_msg;
 	unsigned int weight, pref_weight;
 	unsigned int func_code;
-	unsigned short *domain;
+	unsigned short *domain, tdom;
 	int qid = 0, rc = -ENODEV;
 	struct module *mod;
 
@@ -834,6 +834,17 @@ static long _zcrypt_send_cprb(struct ap_perms *perms,
 	if (rc)
 		goto out;
 
+	/*
+	 * If a valid target domain is set and this domain is NOT a usage
+	 * domain but a control only domain, use the default domain as target.
+	 */
+	tdom = *domain;
+	if (tdom >= 0 && tdom < AP_DOMAINS &&
+	    !ap_test_config_usage_domain(tdom) &&
+	    ap_test_config_ctrl_domain(tdom) &&
+	    ap_domain_index >= 0)
+		tdom = ap_domain_index;
+
 	pref_zc = NULL;
 	pref_zq = NULL;
 	spin_lock(&zcrypt_list_lock);
@@ -856,8 +867,8 @@ static long _zcrypt_send_cprb(struct ap_perms *perms,
 			/* check if device is online and eligible */
 			if (!zq->online ||
 			    !zq->ops->send_cprb ||
-			    ((*domain != (unsigned short) AUTOSELECT) &&
-			     (*domain != AP_QID_QUEUE(zq->queue->qid))))
+			    (tdom != (unsigned short) AUTOSELECT &&
+			     tdom != AP_QID_QUEUE(zq->queue->qid)))
 				continue;
 			/* check if device node has admission for this queue */
 			if (!zcrypt_check_queue(perms,
-- 
2.20.1



