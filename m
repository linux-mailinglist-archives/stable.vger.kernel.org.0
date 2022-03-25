Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972A74E775F
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376845AbiCYP2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376342AbiCYPWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:22:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AC06C93F;
        Fri, 25 Mar 2022 08:16:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD54360AE0;
        Fri, 25 Mar 2022 15:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4069C340E9;
        Fri, 25 Mar 2022 15:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221354;
        bh=PVvpZe0gwx7cCv7/Tokda8oeLwGKuYAWw5qH3QerL9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qvn/GrczFNU1b47SvZkOXh61ieUfwNDdAGOx3/9kAIP9dSJurGaCfe1PwLf4rhPMH
         tV1DeHtmUmy/Z9F1baJTCSsIeNNwwLKGyOrI4gDEgMllE/eTJcbSOhwyk4RIBi9DRu
         UTrc1UZFRMafB3nDwK9gSAy5/zcNCnx/DIRL7IgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        syzbot+e9072e90624a31dfa85f@syzkaller.appspotmail.com,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 5.15 30/37] drm/virtio: Ensure that objs is not NULL in virtio_gpu_array_put_free()
Date:   Fri, 25 Mar 2022 16:14:31 +0100
Message-Id: <20220325150420.791591767@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150419.931802116@linuxfoundation.org>
References: <20220325150419.931802116@linuxfoundation.org>
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

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 6b79f96f4a23846516e5e6e4dd37fc06f43a60dd upstream.

If virtio_gpu_object_shmem_init() fails (e.g. due to fault injection, as it
happened in the bug report by syzbot), virtio_gpu_array_put_free() could be
called with objs equal to NULL.

Ensure that objs is not NULL in virtio_gpu_array_put_free(), or otherwise
return from the function.

Cc: stable@vger.kernel.org # 5.13.x
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reported-by: syzbot+e9072e90624a31dfa85f@syzkaller.appspotmail.com
Fixes: 377f8331d0565 ("drm/virtio: fix possible leak/unlock virtio_gpu_object_array")
Link: http://patchwork.freedesktop.org/patch/msgid/20211213183122.838119-1-roberto.sassu@huawei.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_gem.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/virtio/virtgpu_gem.c
+++ b/drivers/gpu/drm/virtio/virtgpu_gem.c
@@ -248,6 +248,9 @@ void virtio_gpu_array_put_free(struct vi
 {
 	u32 i;
 
+	if (!objs)
+		return;
+
 	for (i = 0; i < objs->nents; i++)
 		drm_gem_object_put(objs->objs[i]);
 	virtio_gpu_array_free(objs);


