Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40CA04B1C0B
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 03:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347196AbiBKCOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 21:14:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347218AbiBKCOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 21:14:14 -0500
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690C35FB9;
        Thu, 10 Feb 2022 18:14:14 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:57088)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nILRt-000fSD-Ju; Thu, 10 Feb 2022 19:14:13 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:52650 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nILRr-00FMXV-Lf; Thu, 10 Feb 2022 19:14:13 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Solar Designer <solar@openwall.com>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        containers@lists.linux-foundation.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
Date:   Thu, 10 Feb 2022 20:13:21 -0600
Message-Id: <20220211021324.4116773-5-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nILRr-00FMXV-Lf;;;mid=<20220211021324.4116773-5-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19+LUNNXy+P6wbS8hab2BGjP4edjzZTdos=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;linux-kernel@vger.kernel.org
X-Spam-Relay-Country: 
X-Spam-Timing: total 1305 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 4.0 (0.3%), b_tie_ro: 2.7 (0.2%), parse: 0.68
        (0.1%), extract_message_metadata: 8 (0.6%), get_uri_detail_list: 0.97
        (0.1%), tests_pri_-1000: 10 (0.8%), tests_pri_-950: 1.06 (0.1%),
        tests_pri_-900: 0.80 (0.1%), tests_pri_-90: 50 (3.8%), check_bayes: 49
        (3.7%), b_tokenize: 4.2 (0.3%), b_tok_get_all: 5 (0.4%), b_comp_prob:
        1.18 (0.1%), b_tok_touch_all: 35 (2.7%), b_finish: 0.77 (0.1%),
        tests_pri_0: 1217 (93.3%), check_dkim_signature: 0.39 (0.0%),
        check_dkim_adsp: 2.5 (0.2%), poll_dns_idle: 0.78 (0.1%), tests_pri_10:
        2.8 (0.2%), tests_pri_500: 8 (0.6%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH 5/8] ucounts: Handle wrapping in is_ucounts_overlimit
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While examining is_ucounts_overlimit and reading the various messages
I realized that is_ucounts_overlimit fails to deal with counts that
may have wrapped.

Being wrapped should be a transitory state for counts and they should
never be wrapped for long, but it can happen so handle it.

Cc: stable@vger.kernel.org
Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/ucount.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index 65b597431c86..06ea04d44685 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -350,7 +350,8 @@ bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, unsign
 	if (rlimit > LONG_MAX)
 		max = LONG_MAX;
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
-		if (get_ucounts_value(iter, type) > max)
+		long val = get_ucounts_value(iter, type);
+		if (val < 0 || val > max)
 			return true;
 		max = READ_ONCE(iter->ns->ucount_max[type]);
 	}
-- 
2.29.2

