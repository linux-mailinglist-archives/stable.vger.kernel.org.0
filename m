Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68BA110BAFF
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732766AbfK0VIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:08:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731761AbfK0VIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:08:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0665F217BA;
        Wed, 27 Nov 2019 21:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888915;
        bh=Mu8/QGb2c/oeq4mNDzhCm1G0evuaFId6DUaoke7BP1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rc+rEXBaS15mmrE2CzycRSxJgBIYMhxr3r5G8RbuUn/A9DxTEBoAm6GnDbWEA3O1o
         9og8uPGdd6Xm8lduq3FwgUopOjUwKYUIR6KlmRkMdhJjMEN0n6c3C8z2Oqs1MijZqC
         d17VXITZlzCdQ9XgKsrq8Fc8t75hpHorQ+faReo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 13/95] taprio: dont reject same mqprio settings
Date:   Wed, 27 Nov 2019 21:31:30 +0100
Message-Id: <20191127202850.086969835@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

[ Upstream commit b5a0faa3572ac70bd374bd66190ac3ad4fddab20 ]

The taprio qdisc allows to set mqprio setting but only once. In case
if mqprio settings are provided next time the error is returned as
it's not allowed to change traffic class mapping in-flignt and that
is normal. But if configuration is absolutely the same - no need to
return error. It allows to provide same command couple times,
changing only base time for instance, or changing only scheds maps,
but leaving mqprio setting w/o modification. It more corresponds the
message: "Changing the traffic mapping of a running schedule is not
supported", so reject mqprio if it's really changed.

Also corrected TC_BITMASK + 1 for consistency, as proposed.

Fixes: a3d43c0d56f1 ("taprio: Add support adding an admin schedule")
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -842,7 +842,7 @@ static int taprio_parse_mqprio_opt(struc
 	}
 
 	/* Verify priority mapping uses valid tcs */
-	for (i = 0; i < TC_BITMASK + 1; i++) {
+	for (i = 0; i <= TC_BITMASK; i++) {
 		if (qopt->prio_tc_map[i] >= qopt->num_tc) {
 			NL_SET_ERR_MSG(extack, "Invalid traffic class in priority to traffic class mapping");
 			return -EINVAL;
@@ -1014,6 +1014,26 @@ static void setup_txtime(struct taprio_s
 	}
 }
 
+static int taprio_mqprio_cmp(const struct net_device *dev,
+			     const struct tc_mqprio_qopt *mqprio)
+{
+	int i;
+
+	if (!mqprio || mqprio->num_tc != dev->num_tc)
+		return -1;
+
+	for (i = 0; i < mqprio->num_tc; i++)
+		if (dev->tc_to_txq[i].count != mqprio->count[i] ||
+		    dev->tc_to_txq[i].offset != mqprio->offset[i])
+			return -1;
+
+	for (i = 0; i <= TC_BITMASK; i++)
+		if (dev->prio_tc_map[i] != mqprio->prio_tc_map[i])
+			return -1;
+
+	return 0;
+}
+
 static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
@@ -1065,6 +1085,10 @@ static int taprio_change(struct Qdisc *s
 	admin = rcu_dereference(q->admin_sched);
 	rcu_read_unlock();
 
+	/* no changes - no new mqprio settings */
+	if (!taprio_mqprio_cmp(dev, mqprio))
+		mqprio = NULL;
+
 	if (mqprio && (oper || admin)) {
 		NL_SET_ERR_MSG(extack, "Changing the traffic mapping of a running schedule is not supported");
 		err = -ENOTSUPP;
@@ -1132,7 +1156,7 @@ static int taprio_change(struct Qdisc *s
 					    mqprio->offset[i]);
 
 		/* Always use supplied priority mappings */
-		for (i = 0; i < TC_BITMASK + 1; i++)
+		for (i = 0; i <= TC_BITMASK; i++)
 			netdev_set_prio_tc_map(dev, i,
 					       mqprio->prio_tc_map[i]);
 	}


