Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2A77506F6
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbfFXKDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728729AbfFXKC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:02:58 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7046213F2;
        Mon, 24 Jun 2019 10:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370577;
        bh=Y3HZqlrrfBVEzvWn6PBI17JimTEKz0cPbi6GIz8VNz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tr4Qz0Hvrar4SQWBd1v61bNhdCrzuzsA+cS4NIxEK12nbc5ceDYr0Fkh9l8aCxd3N
         0eWQUlf68zR7grJ02LAfBRhAeDr3912Swmuuy7MO22FgRTa4MHHa2TzOsuWJLIs2Ze
         jjOn6s26dcN7dGrh/pYnwN6kvJ9/FX1HBJxihELs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Johansen <john.johansen@canonical.com>
Subject: [PATCH 4.19 26/90] apparmor: fix PROFILE_MEDIATES for untrusted input
Date:   Mon, 24 Jun 2019 17:56:16 +0800
Message-Id: <20190624092315.880299660@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

commit 23375b13f98c5464c2b4d15f983cc062940f1f4e upstream.

While commit 11c236b89d7c2 ("apparmor: add a default null dfa") ensure
every profile has a policy.dfa it does not resize the policy.start[]
to have entries for every possible start value. Which means
PROFILE_MEDIATES is not safe to use on untrusted input. Unforunately
commit b9590ad4c4f2 ("apparmor: remove POLICY_MEDIATES_SAFE") did not
take into account the start value usage.

The input string in profile_query_cb() is user controlled and is not
properly checked to be within the limited start[] entries, even worse
it can't be as userspace policy is allowed to make us of entries types
the kernel does not know about. This mean usespace can currently cause
the kernel to access memory up to 240 entries beyond the start array
bounds.

Cc: stable@vger.kernel.org
Fixes: b9590ad4c4f2 ("apparmor: remove POLICY_MEDIATES_SAFE")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/apparmor/include/policy.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -214,7 +214,16 @@ static inline struct aa_profile *aa_get_
 	return labels_profile(aa_get_newest_label(&p->label));
 }
 
-#define PROFILE_MEDIATES(P, T)  ((P)->policy.start[(unsigned char) (T)])
+static inline unsigned int PROFILE_MEDIATES(struct aa_profile *profile,
+					    unsigned char class)
+{
+	if (class <= AA_CLASS_LAST)
+		return profile->policy.start[class];
+	else
+		return aa_dfa_match_len(profile->policy.dfa,
+					profile->policy.start[0], &class, 1);
+}
+
 static inline unsigned int PROFILE_MEDIATES_AF(struct aa_profile *profile,
 					       u16 AF) {
 	unsigned int state = PROFILE_MEDIATES(profile, AA_CLASS_NET);


