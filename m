Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2177712EF2C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgABWny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:43:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:42130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730667AbgABWeD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:34:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D5E721835;
        Thu,  2 Jan 2020 22:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004443;
        bh=nQT92VES4cV9D+HrZBfDmZA5vdKgHGuMiMjlgpw1iqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOYf2dkM9tK8dUzs52JWNtj0cU9H7HIFuhbKLEnTfXo14/wvhzmg/9mMXJqGfnSLm
         cek/rAtvlpuLg/co8hLOXrUC+tt74WCCcImRV8HemNXOMU8Xr3mtwbJQbRPfUIh8l9
         YsW9tix81byUhTX/5j8sSWSsGHOD2VarH36GDGWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.4 001/137] btrfs: do not leak reloc root if we fail to read the fs root
Date:   Thu,  2 Jan 2020 23:06:14 +0100
Message-Id: <20200102220546.831163853@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit ca1aa2818a53875cfdd175fb5e9a2984e997cce9 upstream.

If we fail to read the fs root corresponding with a reloc root we'll
just break out and free the reloc roots.  But we remove our current
reloc_root from this list higher up, which means we'll leak this
reloc_root.  Fix this by adding ourselves back to the reloc_roots list
so we are properly cleaned up.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4454,6 +4454,7 @@ int btrfs_recover_relocation(struct btrf
 				       reloc_root->root_key.offset);
 		if (IS_ERR(fs_root)) {
 			err = PTR_ERR(fs_root);
+			list_add_tail(&reloc_root->root_list, &reloc_roots);
 			goto out_free;
 		}
 


