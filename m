Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D6466C56A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbjAPQFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbjAPQFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:05:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E97124480
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:03:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13F40B80DC7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75473C433D2;
        Mon, 16 Jan 2023 16:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885023;
        bh=cMUV+0rexTPjeMjaEKnfHP+cJEkFgXqd2FS4IWcfO0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6C+FQ4wO/5mFGv8Q7c4RzRHLTZIZdod+Fa5JjKoqKzJB4x+q6z+UA1xZXEsThUdv
         aPXNT65N9TYDXyku/93m7+EtTvl+TbPcYadxa/ovOSbOAOe/HMiehNN/wlk7AWKDZ8
         YvBFjy//31eV4qgS/plrFecxDeO6OfVIBN2dgIIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/86] scsi: mpi3mr: Refer CONFIG_SCSI_MPI3MR in Makefile
Date:   Mon, 16 Jan 2023 16:51:20 +0100
Message-Id: <20230116154748.986348913@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit f0a43ba6c66cc0688e2748d986a1459fdd3442ef ]

When Kconfig item CONFIG_SCSI_MPI3MR was introduced for mpi3mr driver, the
Makefile of the driver was not modified to refer the Kconfig item.

As a result, mpi3mr.ko is built regardless of the Kconfig item value y or
m. Also, if 'make localmodconfig' can not find the Kconfig item in the
Makefile, then it does not generate CONFIG_SCSI_MPI3MR=m even when
mpi3mr.ko is loaded on the system.

Refer to the Kconfig item to avoid the issues.

Fixes: c4f7ac64616e ("scsi: mpi3mr: Add mpi30 Rev-R headers and Kconfig")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20221207023659.2411785-1-shinichiro.kawasaki@wdc.com
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/Makefile b/drivers/scsi/mpi3mr/Makefile
index 7c2063e04c81..7ebca0ba538d 100644
--- a/drivers/scsi/mpi3mr/Makefile
+++ b/drivers/scsi/mpi3mr/Makefile
@@ -1,4 +1,4 @@
 # mpi3mr makefile
-obj-m += mpi3mr.o
+obj-$(CONFIG_SCSI_MPI3MR) += mpi3mr.o
 mpi3mr-y +=  mpi3mr_os.o     \
 		mpi3mr_fw.o \
-- 
2.35.1



