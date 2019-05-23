Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A816927893
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 10:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfEWI4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 04:56:13 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59479 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbfEWI4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 04:56:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5C55C2F5CB;
        Thu, 23 May 2019 04:56:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 23 May 2019 04:56:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4xSHW9
        JObLIzlqvEzG9O6T0sJuqTICE8gV7M3iD5M/I=; b=TeaY1tcwmo6+8yN24rOV04
        BViMlvtXYWph2Es8pd/GT/BEFsiiQlRhC4mjS7wAaJjFY7De0vG9ogWO4U+NltJS
        cek7KP8gHOoKtvzZOtZOtYINKoHSZt3tf6PWRyXBwnn2fpKQFEIWbK+AJ7jZ6BHx
        UqVYjwEK8tcNDV/aLMxmRKoaK9flJYsPBNP9F0diyPNrSXCJj/veWzE+MJNhxwZm
        VQkpsa8vw/U43ACORzDPDfJwE12mM2w9KR9S1aRJB8ZdHg/ZRIR7hMACSSFzAv8L
        29Cb5JyQdSpnenftF29i4h3j5BsNenMF2YZ1YeF968vkLkP00Iwq7czE+5+qGuqg
        ==
X-ME-Sender: <xms:LGDmXJpec31AyLB8qpIbmrwKrQKP2VD99R9q6YxmREeinayN3HtOxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:LGDmXKKOepzP70VqTxAofke84NjghXNdQvNY6V5GtAHnhSHMgbTJBQ>
    <xmx:LGDmXMjLIqrVdgJyvcoaNoGODPGEiEzEqSLE-rwwLXPXZkVEb5O5aQ>
    <xmx:LGDmXLevx0VgIkdUf00UhtYGdFvoR-HyK6mMnEkxatrydZgoMdn33g>
    <xmx:LGDmXJXtPfywL-Ks72gSAJmVqGlrGMhQIwO1DQW4_iZLHzFU9P1pBw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8B6A80059;
        Thu, 23 May 2019 04:56:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/ipoib: Allow user space differentiate between valid" failed to apply to 4.19-stable tree
To:     leonro@mellanox.com, jgg@mellanox.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 May 2019 10:56:09 +0200
Message-ID: <155860176944242@kroah.com>
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

From b79656ed44c6865e17bcd93472ec39488bcc4984 Mon Sep 17 00:00:00 2001
From: Leon Romanovsky <leonro@mellanox.com>
Date: Mon, 6 May 2019 14:23:04 +0300
Subject: [PATCH] RDMA/ipoib: Allow user space differentiate between valid
 dev_port

Systemd triggers the following warning during IPoIB device load:

 mlx5_core 0000:00:0c.0 ib0: "systemd-udevd" wants to know my dev_id.
        Should it look at dev_port instead?
        See Documentation/ABI/testing/sysfs-class-net for more info.

This is caused due to user space attempt to differentiate old systems
without dev_port and new systems with dev_port. In case dev_port will be
zero, the systemd will try to read dev_id instead.

There is no need to print a warning in such case, because it is valid
situation and it is needed to ensure systemd compatibility with old
kernels.

Link: https://github.com/systemd/systemd/blob/master/src/udev/udev-builtin-net_id.c#L358
Cc: <stable@vger.kernel.org> # 4.19
Fixes: f6350da41dc7 ("IB/ipoib: Log sysfs 'dev_id' accesses from userspace")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 48eda16db1a7..9b5e11d3fb85 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2402,7 +2402,18 @@ static ssize_t dev_id_show(struct device *dev,
 {
 	struct net_device *ndev = to_net_dev(dev);
 
-	if (ndev->dev_id == ndev->dev_port)
+	/*
+	 * ndev->dev_port will be equal to 0 in old kernel prior to commit
+	 * 9b8b2a323008 ("IB/ipoib: Use dev_port to expose network interface
+	 * port numbers") Zero was chosen as special case for user space
+	 * applications to fallback and query dev_id to check if it has
+	 * different value or not.
+	 *
+	 * Don't print warning in such scenario.
+	 *
+	 * https://github.com/systemd/systemd/blob/master/src/udev/udev-builtin-net_id.c#L358
+	 */
+	if (ndev->dev_port && ndev->dev_id == ndev->dev_port)
 		netdev_info_once(ndev,
 			"\"%s\" wants to know my dev_id. Should it look at dev_port instead? See Documentation/ABI/testing/sysfs-class-net for more info.\n",
 			current->comm);

