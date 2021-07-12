Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B433C507E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244474AbhGLHdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239988AbhGLHbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:31:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0765461166;
        Mon, 12 Jul 2021 07:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074927;
        bh=gItOOfv8KT+DeesGlj+csdQNBolXuzcvNbXhTlXJxFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJePt6DPJog9d7osGNYGq3IkYyrURka4obksY5RnBgeRWPLgK9XHqtcIZ4NFZdLMg
         tX1Z9LMz213lBwNzvdeP7XwDdaZNVFuHOQWyK0+b/0ge3VpxgCQ2bXprMd+gvRtF03
         +CZ5foBTAOFUYzSLXYb6C3h/4kwUcvJh4v76PhaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.13 046/800] btrfs: zoned: print message when zone sanity check type fails
Date:   Mon, 12 Jul 2021 08:01:09 +0200
Message-Id: <20210712060919.873996090@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 47cdfb5e1dd60422ec2cbc53b667f73ff9a411dc upstream.

This extends patch 784daf2b9628 ("btrfs: zoned: sanity check zone
type"), the message was supposed to be there but was lost during merge.
We want to make the error noticeable so add it.

Fixes: 784daf2b9628 ("btrfs: zoned: sanity check zone type")
CC: stable@vger.kernel.org # 5.12+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/zoned.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1140,6 +1140,10 @@ int btrfs_load_block_group_zone_info(str
 		}
 
 		if (zone.type == BLK_ZONE_TYPE_CONVENTIONAL) {
+			btrfs_err_in_rcu(fs_info,
+	"zoned: unexpected conventional zone %llu on device %s (devid %llu)",
+				zone.start << SECTOR_SHIFT,
+				rcu_str_deref(device->name), device->devid);
 			ret = -EIO;
 			goto out;
 		}


