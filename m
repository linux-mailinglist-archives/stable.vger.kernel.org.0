Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337C5548816
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378463AbiFMNlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379150AbiFMNj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE22D2253A;
        Mon, 13 Jun 2022 04:29:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66A18B80D3A;
        Mon, 13 Jun 2022 11:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28A7C34114;
        Mon, 13 Jun 2022 11:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119738;
        bh=XAepP+VO+bU1kBLylU6LOD5IZD0Sfi2Ra4R0TzkzD6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BT6D+Qs7DHt2DzYoSCl4V30I03LfNSGVOmACyDZcXPyFCbCSsI9ccZWIgOxLEFLWt
         BMd9Sl6MQ5F8m3j5QcEgaIp5aJJzyg6SLt5h5Re/4SJxc9+fGJmWJRYG5ID6rFGuxj
         mP9VY4mk1oQJHabtJrYdzGDN3RcNh1dXJjKhK6Aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Si-Wei Liu <si-wei.liu@oracle.com>,
        Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 122/339] vdpa: Fix error logic in vdpa_nl_cmd_dev_get_doit
Date:   Mon, 13 Jun 2022 12:09:07 +0200
Message-Id: <20220613094930.208721378@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 7a6691f1f89784f775fa0c54be57533445726068 ]

In vdpa_nl_cmd_dev_get_doit(), if the call to genlmsg_reply() fails we
must not call nlmsg_free() since this is done inside genlmsg_reply().

Fix it.

Fixes: bc0d90ee021f ("vdpa: Enable user to query vdpa device info")
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
Message-Id: <20220518133804.1075129-2-elic@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 2b75c00b1005..fac89a0d8178 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -756,14 +756,19 @@ static int vdpa_nl_cmd_dev_get_doit(struct sk_buff *skb, struct genl_info *info)
 		goto mdev_err;
 	}
 	err = vdpa_dev_fill(vdev, msg, info->snd_portid, info->snd_seq, 0, info->extack);
-	if (!err)
-		err = genlmsg_reply(msg, info);
+	if (err)
+		goto mdev_err;
+
+	err = genlmsg_reply(msg, info);
+	put_device(dev);
+	mutex_unlock(&vdpa_dev_mutex);
+	return err;
+
 mdev_err:
 	put_device(dev);
 err:
 	mutex_unlock(&vdpa_dev_mutex);
-	if (err)
-		nlmsg_free(msg);
+	nlmsg_free(msg);
 	return err;
 }
 
-- 
2.35.1



