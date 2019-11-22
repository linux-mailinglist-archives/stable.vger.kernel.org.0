Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 993FE10710E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfKVLZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:25:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727138AbfKVKfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:35:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69F5B20656;
        Fri, 22 Nov 2019 10:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418941;
        bh=mrspe+mgrglRZ+D3kuEHu3waRfdkiGhHWKCwrtBFpzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=It8mmwaZFEpbEvsz8wR+DFl83nysC2wug0wlS/ZLP9SjyInaKH0dVjTU1RM//1pAj
         RrW74YLxHgTAEZ9tY5LAVPAJY7IV53Ojqa//YE5X4CgXZJ6MIlcRp9GfJhJPuPoGt5
         JKxBIesTyn2ZaDkvOYKsCaqOYXdPI0dgxKH3pOEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>,
        Seth Arnold <seth.arnold@canonical.com>
Subject: [PATCH 4.4 103/159] apparmor: fix update the mtime of the profile file on replacement
Date:   Fri, 22 Nov 2019 11:28:14 +0100
Message-Id: <20191122100822.307982733@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

commit d671e890205a663429da74e1972e652bea4d73ab upstream.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Acked-by: Seth Arnold <seth.arnold@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/apparmor/apparmorfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -380,6 +380,8 @@ void __aa_fs_profile_migrate_dents(struc
 
 	for (i = 0; i < AAFS_PROF_SIZEOF; i++) {
 		new->dents[i] = old->dents[i];
+		if (new->dents[i])
+			new->dents[i]->d_inode->i_mtime = CURRENT_TIME;
 		old->dents[i] = NULL;
 	}
 }


