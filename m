Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A600D1A9BA9
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408847AbgDOLED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:04:03 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41991 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896698AbgDOLCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:02:51 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3D1095C0145;
        Wed, 15 Apr 2020 07:02:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:02:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9yrWIB
        MZ9yYNY2Ijl3tX3Dmvq5x8A0o9it7hq5KyAn8=; b=Uc1bl5xRBnHsM07j5bvUtG
        lWwt03J5nL3T4i6G6Yay+N8rmdHPwM3Tenjx/F+Vz0a+6WDZqLRRgwXvs0nYWAK5
        Ffmw1SX5H+ZT929SSMNfkqd+x6XWwlo7GJa5vZSNqjFVvMIWkGnbkPhSzSSP5quH
        eczdXyMKeMKEm+h4Tv9r5Y7lfPyhRiShkTWbUin+39vEznq/UnSrYIuPk4BYp9dx
        jMhhSVlvNpa9/Alq6KsiyKEkjSWaEy9/W29TmZ1DpDBU++tbnoyEWDLd+LzcYivh
        HeNBk99j0bhI8qblueBFQQ2cS41xjCf0kDgO83ZEqaPvVkI8FfRXgOuN0DVW1liA
        ==
X-ME-Sender: <xms:2umWXtit0-a_m0RjfjA4OTJDwbHuhDv3G3m9WZtB09a5omTfpQHuqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:2umWXq1RMRRr7FDxm6-mpNzC3IKh2DTuI3hFk3C2Xez0VRKrtoM13A>
    <xmx:2umWXjZ9Rs2rldwierSfYEmX8VQOG6ndjaWTnAyxMTc23mulwSjcoA>
    <xmx:2umWXo5J1u5BoYWo0I8XP7j5aGEZr5Lb4YM1hP-CoWwOmk12cJqVZQ>
    <xmx:2umWXgICepMzGHLbpjXI4I58EgGgKNluEMR838pBOUTy5EYnMQhsUA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C2E70306005B;
        Wed, 15 Apr 2020 07:02:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm zoned: remove duplicate nr_rnd_zones increase in" failed to apply to 4.14-stable tree
To:     bob.liu@oracle.com, damien.lemoal@wdc.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:02:40 +0200
Message-ID: <158694856063129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

