Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DE52A8405
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 17:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbgKEQwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 11:52:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731120AbgKEQwg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 11:52:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00D522073A;
        Thu,  5 Nov 2020 16:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604595154;
        bh=MozR4hVox5M98dZBu4bljdXBdfLzcfI3CZBwTVIRFDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMEvJl76WyCPGR7EtS0P1egRcByOdqeTXionLFVB8nfTYRiYH6ywGUduZFGtZ8Zru
         IPN4NiUpuj71uUe9yy6qLZkSAHnBeAAMFCn6Y8JTM9m3UCwXqLaZ9Hld4+fAOnLPDf
         b07lf9KXZrAMYMyZDBdVCoJjaqQ04OPCy+rzURoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.9.6
Date:   Thu,  5 Nov 2020 17:53:14 +0100
Message-Id: <160459513215496@kroah.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <16045951328381@kroah.com>
References: <16045951328381@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 27d4fe12da24..2fed32cac74e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 9
-SUBLEVEL = 5
+SUBLEVEL = 6
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
index c475955c6eeb..9500572c0e31 100644
--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -178,6 +178,11 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
 	}
 
 	return ret;
+
+error:
+	snd_hdac_ext_bus_device_exit(hdev);
+	return -ENOENT;
+
 #else
 	hdev = devm_kzalloc(sdev->dev, sizeof(*hdev), GFP_KERNEL);
 	if (!hdev)
