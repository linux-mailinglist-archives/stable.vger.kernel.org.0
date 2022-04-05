Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B925C4F3DF1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377219AbiDEMXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356145AbiDEKW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:22:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457FEB9192;
        Tue,  5 Apr 2022 03:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D41DA6176C;
        Tue,  5 Apr 2022 10:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B6FC385A2;
        Tue,  5 Apr 2022 10:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153207;
        bh=NtlPD9CTty6noCRJOfFwOvQ/dLso2c2lHtPEiGjUHoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBWB7Ce4XbnQTDpg3gQIkDmEugntHb2d5WQctQ9Qfl72HkJxO6RgWN3jxJ5Eje2TM
         ACeGAqrFWs7Jv/nh4wSxxHK5NhMGC0LrQYnuUzsCsKnewMKK/vwWlpugz031tEfMuo
         kErSGZXC2k8yaYqQcbLp/6mHUsG5AsQpIK2bVjrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/599] audit: log AUDIT_TIME_* records only from rules
Date:   Tue,  5 Apr 2022 09:27:14 +0200
Message-Id: <20220405070303.007776602@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

[ Upstream commit 272ceeaea355214b301530e262a0df8600bfca95 ]

AUDIT_TIME_* events are generated when there are syscall rules present
that are not related to time keeping.  This will produce noisy log
entries that could flood the logs and hide events we really care about.

Rather than immediately produce the AUDIT_TIME_* records, store the data
in the context and log it at syscall exit time respecting the filter
rules.

Note: This eats the audit_buffer, unlike any others in show_special().

Please see https://bugzilla.redhat.com/show_bug.cgi?id=1991919

Fixes: 7e8eda734d30 ("ntp: Audit NTP parameters adjustment")
Fixes: 2d87a0674bd6 ("timekeeping: Audit clock adjustments")
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
[PM: fixed style/whitespace issues]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/audit.h   |  4 +++
 kernel/auditsc.c | 87 +++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 71 insertions(+), 20 deletions(-)

diff --git a/kernel/audit.h b/kernel/audit.h
index 3b9c0945225a..1918019e6aaf 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -191,6 +191,10 @@ struct audit_context {
 		struct {
 			char			*name;
 		} module;
+		struct {
+			struct audit_ntp_data	ntp_data;
+			struct timespec64	tk_injoffset;
+		} time;
 	};
 	int fds[2];
 	struct audit_proctitle proctitle;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 638f424859ed..07e2788bbbf1 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1214,6 +1214,53 @@ static void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
 			 from_kuid(&init_user_ns, name->fcap.rootid));
 }
 
+static void audit_log_time(struct audit_context *context, struct audit_buffer **ab)
+{
+	const struct audit_ntp_data *ntp = &context->time.ntp_data;
+	const struct timespec64 *tk = &context->time.tk_injoffset;
+	static const char * const ntp_name[] = {
+		"offset",
+		"freq",
+		"status",
+		"tai",
+		"tick",
+		"adjust",
+	};
+	int type;
+
+	if (context->type == AUDIT_TIME_ADJNTPVAL) {
+		for (type = 0; type < AUDIT_NTP_NVALS; type++) {
+			if (ntp->vals[type].newval != ntp->vals[type].oldval) {
+				if (!*ab) {
+					*ab = audit_log_start(context,
+							GFP_KERNEL,
+							AUDIT_TIME_ADJNTPVAL);
+					if (!*ab)
+						return;
+				}
+				audit_log_format(*ab, "op=%s old=%lli new=%lli",
+						 ntp_name[type],
+						 ntp->vals[type].oldval,
+						 ntp->vals[type].newval);
+				audit_log_end(*ab);
+				*ab = NULL;
+			}
+		}
+	}
+	if (tk->tv_sec != 0 || tk->tv_nsec != 0) {
+		if (!*ab) {
+			*ab = audit_log_start(context, GFP_KERNEL,
+					      AUDIT_TIME_INJOFFSET);
+			if (!*ab)
+				return;
+		}
+		audit_log_format(*ab, "sec=%lli nsec=%li",
+				 (long long)tk->tv_sec, tk->tv_nsec);
+		audit_log_end(*ab);
+		*ab = NULL;
+	}
+}
+
 static void show_special(struct audit_context *context, int *call_panic)
 {
 	struct audit_buffer *ab;
@@ -1319,6 +1366,11 @@ static void show_special(struct audit_context *context, int *call_panic)
 			audit_log_format(ab, "(null)");
 
 		break;
+	case AUDIT_TIME_ADJNTPVAL:
+	case AUDIT_TIME_INJOFFSET:
+		/* this call deviates from the rest, eating the buffer */
+		audit_log_time(context, &ab);
+		break;
 	}
 	audit_log_end(ab);
 }
@@ -2560,31 +2612,26 @@ void __audit_fanotify(unsigned int response)
 
 void __audit_tk_injoffset(struct timespec64 offset)
 {
-	audit_log(audit_context(), GFP_KERNEL, AUDIT_TIME_INJOFFSET,
-		  "sec=%lli nsec=%li",
-		  (long long)offset.tv_sec, offset.tv_nsec);
-}
-
-static void audit_log_ntp_val(const struct audit_ntp_data *ad,
-			      const char *op, enum audit_ntp_type type)
-{
-	const struct audit_ntp_val *val = &ad->vals[type];
-
-	if (val->newval == val->oldval)
-		return;
+	struct audit_context *context = audit_context();
 
-	audit_log(audit_context(), GFP_KERNEL, AUDIT_TIME_ADJNTPVAL,
-		  "op=%s old=%lli new=%lli", op, val->oldval, val->newval);
+	/* only set type if not already set by NTP */
+	if (!context->type)
+		context->type = AUDIT_TIME_INJOFFSET;
+	memcpy(&context->time.tk_injoffset, &offset, sizeof(offset));
 }
 
 void __audit_ntp_log(const struct audit_ntp_data *ad)
 {
-	audit_log_ntp_val(ad, "offset",	AUDIT_NTP_OFFSET);
-	audit_log_ntp_val(ad, "freq",	AUDIT_NTP_FREQ);
-	audit_log_ntp_val(ad, "status",	AUDIT_NTP_STATUS);
-	audit_log_ntp_val(ad, "tai",	AUDIT_NTP_TAI);
-	audit_log_ntp_val(ad, "tick",	AUDIT_NTP_TICK);
-	audit_log_ntp_val(ad, "adjust",	AUDIT_NTP_ADJUST);
+	struct audit_context *context = audit_context();
+	int type;
+
+	for (type = 0; type < AUDIT_NTP_NVALS; type++)
+		if (ad->vals[type].newval != ad->vals[type].oldval) {
+			/* unconditionally set type, overwriting TK */
+			context->type = AUDIT_TIME_ADJNTPVAL;
+			memcpy(&context->time.ntp_data, ad, sizeof(*ad));
+			break;
+		}
 }
 
 void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
-- 
2.34.1



