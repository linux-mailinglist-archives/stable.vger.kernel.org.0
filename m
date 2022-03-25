Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947C34E7749
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376438AbiCYP1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377975AbiCYPYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:24:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FBAEACA4;
        Fri, 25 Mar 2022 08:19:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52C94B82865;
        Fri, 25 Mar 2022 15:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99D1C340E9;
        Fri, 25 Mar 2022 15:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221569;
        bh=PVvpZe0gwx7cCv7/Tokda8oeLwGKuYAWw5qH3QerL9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZoPoxTMNtHAmIUoLjnxuRT3PdBYvM267NGmipOacVW8d87PqU5d9h//BM5BDOVIu
         TqshdoXAP96N/rekrffrJ6AguM/hLrSnZtK8EeI1I27vEQMxifG4P9nV+NOlxFiMqa
         jIztWLEJ3GNZV4LLpIsvvLQIRRZ/VmNsXIXZ14Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        syzbot+e9072e90624a31dfa85f@syzkaller.appspotmail.com,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 5.17 30/39] drm/virtio: Ensure that objs is not NULL in virtio_gpu_array_put_free()
Date:   Fri, 25 Mar 2022 16:14:45 +0100
Message-Id: <20220325150421.104922740@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.245733653@linuxfoundation.org>
References: <20220325150420.245733653@linuxfoundation.org>
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


