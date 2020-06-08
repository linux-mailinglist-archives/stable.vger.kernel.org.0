Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9748F1F2D47
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733119AbgFIAcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728805AbgFHXPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7D742068D;
        Mon,  8 Jun 2020 23:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658117;
        bh=RIaJwXAv2CIPY/0FDHuz4E1BrCH0mzjtH5iCXkOJkoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjwWNXoMZKjYf98c456Ce2Ewf8zo+umypbZTMXzBKfyiQ2gC5Vj5ELWuolMICNn8L
         +ysvti6pqY+o5yw9MWOUK2vN+cuPaJrIWLbdUITy6ZT43RlYJC/8cPjR6CP75eO8G6
         ynlEMYx3oJW6he7IdbBYtYcpVzyQeg0hp2kCsh4Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        John Johansen <john.johansen@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 155/606] apparmor: Fix aa_label refcnt leak in policy_update
Date:   Mon,  8 Jun 2020 19:04:40 -0400
Message-Id: <20200608231211.3363633-155-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

commit c6b39f070722ea9963ffe756bfe94e89218c5e63 upstream.

policy_update() invokes begin_current_label_crit_section(), which
returns a reference of the updated aa_label object to "label" with
increased refcount.

When policy_update() returns, "label" becomes invalid, so the refcount
should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
policy_update(). When aa_may_manage_policy() returns not NULL, the
refcnt increased by begin_current_label_crit_section() is not decreased,
causing a refcnt leak.

Fix this issue by jumping to "end_section" label when
aa_may_manage_policy() returns not NULL.

Fixes: 5ac8c355ae00 ("apparmor: allow introspecting the loaded policy pre internal transform")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/apparmorfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 280741fc0f5f..f6a3ecfadf80 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -454,7 +454,7 @@ static ssize_t policy_update(u32 mask, const char __user *buf, size_t size,
 	 */
 	error = aa_may_manage_policy(label, ns, mask);
 	if (error)
-		return error;
+		goto end_section;
 
 	data = aa_simple_write_to_buffer(buf, size, size, pos);
 	error = PTR_ERR(data);
@@ -462,6 +462,7 @@ static ssize_t policy_update(u32 mask, const char __user *buf, size_t size,
 		error = aa_replace_profiles(ns, label, mask, data);
 		aa_put_loaddata(data);
 	}
+end_section:
 	end_current_label_crit_section(label);
 
 	return error;
-- 
2.25.1

