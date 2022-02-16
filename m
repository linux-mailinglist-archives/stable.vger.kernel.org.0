Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718C84B8D1A
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 16:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbiBPP7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 10:59:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235841AbiBPP7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 10:59:30 -0500
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012012A797F;
        Wed, 16 Feb 2022 07:59:17 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:58066)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMi4-009INm-QR; Wed, 16 Feb 2022 08:59:16 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37452 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMi3-002YPH-F4; Wed, 16 Feb 2022 08:59:16 -0700
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
        linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
Date:   Wed, 16 Feb 2022 09:58:32 -0600
Message-Id: <20220216155832.680775-5-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
References: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nKMi3-002YPH-F4;;;mid=<20220216155832.680775-5-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/+Ki8jT8CUWv1olHpIGtHW6IqQTF2AmAU=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;linux-kernel@vger.kernel.org
X-Spam-Relay-Country: 
X-Spam-Timing: total 452 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 3.9 (0.9%), b_tie_ro: 2.7 (0.6%), parse: 0.71
        (0.2%), extract_message_metadata: 8 (1.7%), get_uri_detail_list: 0.73
        (0.2%), tests_pri_-1000: 11 (2.3%), tests_pri_-950: 1.35 (0.3%),
        tests_pri_-900: 0.81 (0.2%), tests_pri_-90: 241 (53.4%), check_bayes:
        240 (53.1%), b_tokenize: 4.4 (1.0%), b_tok_get_all: 5 (1.2%),
        b_comp_prob: 1.35 (0.3%), b_tok_touch_all: 226 (49.9%), b_finish: 0.85
        (0.2%), tests_pri_0: 176 (38.9%), check_dkim_signature: 0.39 (0.1%),
        check_dkim_adsp: 1.70 (0.4%), poll_dns_idle: 0.39 (0.1%),
        tests_pri_10: 1.77 (0.4%), tests_pri_500: 6 (1.3%), rewrite_mail: 0.00
        (0.0%)
Subject: [PATCH v2 5/5] ucounts: Handle wrapping in is_ucounts_overlimit
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

