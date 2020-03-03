Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C99177F43
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbgCCRtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:49:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731796AbgCCRth (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:49:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60D0820CC7;
        Tue,  3 Mar 2020 17:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257775;
        bh=i3RE9DoqeuTrvtoJD17oadaBmZeIBy8aamchigfCcwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uB7/BlhcT/lpYPyodnN4HwEtgZRks/+o2u3c3F6k/ubPSI36vcCimJqjU3E7GCAXq
         fF0PweUc0Oavtx9UIHXMmF8MZ7FnzBdI5BXI13YQDWu64Z95JIs3A6XzLk6mIZa23p
         /M/TxKYfQthoYaGF1MeKzJS6lB8SQLJCJw27Fhsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 124/176] s390/qeth: vnicc Fix EOPNOTSUPP precedence
Date:   Tue,  3 Mar 2020 18:43:08 +0100
Message-Id: <20200303174319.138458807@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

commit 6f3846f0955308b6d1b219419da42b8de2c08845 upstream.

When getting or setting VNICC parameters, the error code EOPNOTSUPP
should have precedence over EBUSY.

EBUSY is used because vnicc feature and bridgeport feature are mutually
exclusive, which is a temporary condition.
Whereas EOPNOTSUPP indicates that the HW does not support all or parts of
the vnicc feature.
This issue causes the vnicc sysfs params to show 'blocked by bridgeport'
for HW that does not support VNICC at all.

Fixes: caa1f0b10d18 ("s390/qeth: add VNICC enable/disable support")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/net/qeth_l2_main.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1815,15 +1815,14 @@ int qeth_l2_vnicc_set_state(struct qeth_
 
 	QETH_CARD_TEXT(card, 2, "vniccsch");
 
-	/* do not change anything if BridgePort is enabled */
-	if (qeth_bridgeport_is_in_use(card))
-		return -EBUSY;
-
 	/* check if characteristic and enable/disable are supported */
 	if (!(card->options.vnicc.sup_chars & vnicc) ||
 	    !(card->options.vnicc.set_char_sup & vnicc))
 		return -EOPNOTSUPP;
 
+	if (qeth_bridgeport_is_in_use(card))
+		return -EBUSY;
+
 	/* set enable/disable command and store wanted characteristic */
 	if (state) {
 		cmd = IPA_VNICC_ENABLE;
@@ -1869,14 +1868,13 @@ int qeth_l2_vnicc_get_state(struct qeth_
 
 	QETH_CARD_TEXT(card, 2, "vniccgch");
 
-	/* do not get anything if BridgePort is enabled */
-	if (qeth_bridgeport_is_in_use(card))
-		return -EBUSY;
-
 	/* check if characteristic is supported */
 	if (!(card->options.vnicc.sup_chars & vnicc))
 		return -EOPNOTSUPP;
 
+	if (qeth_bridgeport_is_in_use(card))
+		return -EBUSY;
+
 	/* if card is ready, query current VNICC state */
 	if (qeth_card_hw_is_reachable(card))
 		rc = qeth_l2_vnicc_query_chars(card);
@@ -1894,15 +1892,14 @@ int qeth_l2_vnicc_set_timeout(struct qet
 
 	QETH_CARD_TEXT(card, 2, "vniccsto");
 
-	/* do not change anything if BridgePort is enabled */
-	if (qeth_bridgeport_is_in_use(card))
-		return -EBUSY;
-
 	/* check if characteristic and set_timeout are supported */
 	if (!(card->options.vnicc.sup_chars & QETH_VNICC_LEARNING) ||
 	    !(card->options.vnicc.getset_timeout_sup & QETH_VNICC_LEARNING))
 		return -EOPNOTSUPP;
 
+	if (qeth_bridgeport_is_in_use(card))
+		return -EBUSY;
+
 	/* do we need to do anything? */
 	if (card->options.vnicc.learning_timeout == timeout)
 		return rc;
@@ -1931,14 +1928,14 @@ int qeth_l2_vnicc_get_timeout(struct qet
 
 	QETH_CARD_TEXT(card, 2, "vniccgto");
 
-	/* do not get anything if BridgePort is enabled */
-	if (qeth_bridgeport_is_in_use(card))
-		return -EBUSY;
-
 	/* check if characteristic and get_timeout are supported */
 	if (!(card->options.vnicc.sup_chars & QETH_VNICC_LEARNING) ||
 	    !(card->options.vnicc.getset_timeout_sup & QETH_VNICC_LEARNING))
 		return -EOPNOTSUPP;
+
+	if (qeth_bridgeport_is_in_use(card))
+		return -EBUSY;
+
 	/* if card is ready, get timeout. Otherwise, just return stored value */
 	*timeout = card->options.vnicc.learning_timeout;
 	if (qeth_card_hw_is_reachable(card))


