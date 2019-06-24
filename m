Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E834E50782
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbfFXKHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:07:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729814AbfFXKHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:07:35 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0728205C9;
        Mon, 24 Jun 2019 10:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370854;
        bh=d/cT9knU3Q7SoiUiMZRHfIV+IRBC2ybsYASLgBI09oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGyL/7v3s8G3K7qJwgCQ6I0wuuGIuaOM8tqXilH3wRB7YK2aaIe+07xq9HkY1KWD9
         x3F8IYfHKT/nOgihGtvIyXFwrVJ3Fa/ppdxCvhD0FGGqe7VDx1C9s2TI8etl7v2z+k
         VAhIzqQRB514btzY000OM7/tqhGdAzQvGD9wUS+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.1 025/121] apparmor: fix PROFILE_MEDIATES for untrusted input
Date:   Mon, 24 Jun 2019 17:55:57 +0800
Message-Id: <20190624092321.992568736@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
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
@@ -217,7 +217,16 @@ static inline struct aa_profile *aa_get_
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


