Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5625D1A9BA6
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393916AbgDOLDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:03:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51495 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896684AbgDOLCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:02:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 4A5995C0162;
        Wed, 15 Apr 2020 07:02:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:02:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Q5qVYj
        AjWQanFnuiKgEsYY7kVAxw/RH75Iuv1lcCAOQ=; b=CKN7Aba8/juTCtd5Kf0d+g
        wuPdjMSNQbCwk7x7EP4sS7BMnNIuo+F5015YvgpAB6kkMy7uZj8FNTdNzUKx0lj5
        8tWyg13XIgowy87vAohIYvKNuQ0MDlcWMoxp2Elp23GbQNrSK+t8KgeWeAcPJ3hR
        eQsAlPbI1kVzWShBjWgvrpg4EAGGmpJCazAf1r1A2ISCslqVACn4gTcYRNMfa/6K
        roHRcrhUqULoee2059TegyGmdouL5J74YtKPJdvu03NtqgsVzY+4qkj8wNm4BxKd
        ZMt+k5I6JecrhOF+VlMwZm/AIExzRAIR9aVg+/w04ue6pYv8r5dmN9P/zUxRTutw
        ==
X-ME-Sender: <xms:0emWXu6hF_Aub0i3fUYoMIWyVr1xrlx52b8GMm40LnEckRlhnn8uUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:0emWXvITa-h7cRicTLQui_nVyExDnYTpoMqh1jXGDbGP0aWvfmMwnA>
    <xmx:0emWXoUxG5kBT0a3c_X11R94kbh05TlAHX54PJxBPFGlsw3-F2kXig>
    <xmx:0emWXrEbGLuVY4iSOGGRs3STDPp4maBuTmj_nUE3E7VdrKB1bwg4mA>
    <xmx:0umWXhlMQfJ1_jDfy8EhfOA4veBe4lmKxkQCvWdEfELRonIQjAKLFw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E7953280063;
        Wed, 15 Apr 2020 07:02:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm zoned: remove duplicate nr_rnd_zones increase in" failed to apply to 5.4-stable tree
To:     bob.liu@oracle.com, damien.lemoal@wdc.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:02:39 +0200
Message-ID: <15869485594525@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

