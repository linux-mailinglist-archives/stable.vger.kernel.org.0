Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE911A9BAD
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393923AbgDOLDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:03:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59379 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896707AbgDOLCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:02:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id B3AAB5C0153;
        Wed, 15 Apr 2020 07:02:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:02:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KlcKlH
        zKEF93RpM5xbCpUmxgLy3Q43OxDXViyj3IQNU=; b=HNjSsuCBV+OfT8k8fxR9jw
        Rs+bGwram9oiUxcE7Oxq6bxK5n0KSxlABsnkWKytSLAmgPtNkQOcjHH8fujMFGhp
        GIrqpBupJJBpxy2ONPTb2zwXP0EPLt8objnhojdT1fDaPVvXoxtpxDTWQCRA3hA+
        uj4w7Z0AvTMSoIXCCZ4llkAL2qIkeKr1iMOSJ5yHJCeh4en7Qg3SR/j+/LmplRCs
        bpAKwiNhhxNKyxZrXzLCVSSHBAbM3yq0Mx46rB0N+gY6kDDW0jUSt/Z1jBOg34hq
        mDAWqTgYiRz8Ge0LoB0YOceSzxMXtdOaqOQ4N+n6XkNqSBYaYAzFP0uXn6VkB1qQ
        ==
X-ME-Sender: <xms:2-mWXitcOCz0WHPfRY98pOAsG9_iNUG2KU3UpSIdVzFJsAKDeQz8Rg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:2-mWXnnAeSY1LcUGeQCqt3vxw07fMY5lzx1ixl66dmM2LQGdx0O2QA>
    <xmx:2-mWXrkHJh1X27D02c3qV5ARiZkHC9Qf9znfet0zPPw48QahxVuOxA>
    <xmx:2-mWXhe_orQv_7WAn3NfLMD07zs-mdAXz3jo7_DZiqu1-Mat4xq-ew>
    <xmx:2-mWXiuO99jY0YRVrmA58oPSH97vt9Km76FIa2xqFbiSpuoKEzt_LA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F0643280064;
        Wed, 15 Apr 2020 07:02:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm zoned: remove duplicate nr_rnd_zones increase in" failed to apply to 4.19-stable tree
To:     bob.liu@oracle.com, damien.lemoal@wdc.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:02:40 +0200
Message-ID: <158694856060147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b8fdd090376a7a46d17db316638fe54b965c2fb0 Mon Sep 17 00:00:00 2001
From: Bob Liu <bob.liu@oracle.com>
Date: Tue, 24 Mar 2020 21:22:45 +0800
Subject: [PATCH] dm zoned: remove duplicate nr_rnd_zones increase in
 dmz_init_zone()

zmd->nr_rnd_zones was increased twice by mistake. The other place it
is increased in dmz_init_zone() is the only one needed:

1131                 zmd->nr_useable_zones++;
1132                 if (dmz_is_rnd(zone)) {
1133                         zmd->nr_rnd_zones++;
					^^^
Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Signed-off-by: Bob Liu <bob.liu@oracle.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 516c7b671d25..369de15c4e80 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1109,7 +1109,6 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int idx, void *data)
 	switch (blkz->type) {
 	case BLK_ZONE_TYPE_CONVENTIONAL:
 		set_bit(DMZ_RND, &zone->flags);
-		zmd->nr_rnd_zones++;
 		break;
 	case BLK_ZONE_TYPE_SEQWRITE_REQ:
 	case BLK_ZONE_TYPE_SEQWRITE_PREF:

