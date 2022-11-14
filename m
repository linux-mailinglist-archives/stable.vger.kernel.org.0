Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3D5627E6B
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbiKNMrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237157AbiKNMrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:47:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F21BEAA
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:47:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 591F0B80EAE
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC450C433D6;
        Mon, 14 Nov 2022 12:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430054;
        bh=bFyco3II0mogmA4b2u1js9KntL/hWl4kA0OUBaY2vKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QqPy4+8K3Cut5rd4/DHqWQrUW55luUWQIiatAarTkM4ZFnHWLDBvPVytNtcxaKstu
         3WhZUpU3ntGlJdAjs9G6ecpV7ya9ThS2oWZM1KLFccO6Z1GWQGPKAL2NYDnNFMosSn
         77DW/JNg1wliIXKw+TINP8uRIA8K8iN9qecQxoZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pu Lehui <pulehui@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Quentin Monnet <quentin@isovalent.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/95] bpftool: Fix NULL pointer dereference when pin {PROG, MAP, LINK} without FILE
Date:   Mon, 14 Nov 2022 13:45:01 +0100
Message-Id: <20221114124442.840415058@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 34de8e6e0e1f66e431abf4123934a2581cb5f133 ]

When using bpftool to pin {PROG, MAP, LINK} without FILE,
segmentation fault will occur. The reson is that the lack
of FILE will cause strlen to trigger NULL pointer dereference.
The corresponding stacktrace is shown below:

do_pin
  do_pin_any
    do_pin_fd
      mount_bpffs_for_pin
        strlen(name) <- NULL pointer dereference

Fix it by adding validation to the common process.

Fixes: 75a1e792c335 ("tools: bpftool: Allow all prog/map handles for pinning objects")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Link: https://lore.kernel.org/bpf/20221102084034.3342995-1-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 6ebf2b215ef4..eefa2b34e641 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -271,6 +271,9 @@ int do_pin_any(int argc, char **argv, int (*get_fd)(int *, char ***))
 	int err;
 	int fd;
 
+	if (!REQ_ARGS(3))
+		return -EINVAL;
+
 	fd = get_fd(&argc, &argv);
 	if (fd < 0)
 		return fd;
-- 
2.35.1



