Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49783A003B
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhFHSkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235226AbhFHSjX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:39:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E21C361428;
        Tue,  8 Jun 2021 18:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177240;
        bh=Q+50u6VEuJUsIO+N+ebG9YGoOmGd3HBkI4NM1u3jKvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8a7Uki0n4atcEsDsA7rriskitw1NxFRzl91K4rn5YSS8z6gcZschCxwYWEDn7XI9
         k0hjPHSoFeYJBBJZyhq6qMW/27QUUdVgXUE+o664zAcPNVAR6VpwZ3w4+5XIqRvC3V
         TgPpe1ZpLia8v0Db4M1kZ2NBWV63PKpfxbg2/wTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 37/58] btrfs: return errors from btrfs_del_csums in cleanup_ref_head
Date:   Tue,  8 Jun 2021 20:27:18 +0200
Message-Id: <20210608175933.496836042@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 856bd270dc4db209c779ce1e9555c7641ffbc88e upstream.

We are unconditionally returning 0 in cleanup_ref_head, despite the fact
that btrfs_del_csums could fail.  We need to return the error so the
transaction gets aborted properly, fix this by returning ret from
btrfs_del_csums in cleanup_ref_head.

Reviewed-by: Qu Wenruo <wqu@suse.com>
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2501,7 +2501,7 @@ static int cleanup_ref_head(struct btrfs
 				      head->qgroup_reserved);
 	btrfs_delayed_ref_unlock(head);
 	btrfs_put_delayed_ref_head(head);
-	return 0;
+	return ret;
 }
 
 /*


