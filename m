Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5BD899CAF
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387840AbfHVRgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391614AbfHVRYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:55 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6085B2341C;
        Thu, 22 Aug 2019 17:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494694;
        bh=xdalsFCpUsXXAcYol/EVFJq/VSzCZrzFEhP55WIgID8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avYIz4j3JC4A4wlxQXCj0SSj9H3BGLr0kX2oxZkzGpFR1uREWH3j9G1ksNMprgbkW
         wlNCCcKZnYEndxNx25yCeKX9FJ8qQ6FZXzSV0Ve4LTQIXIWuZ0em72bMkVmb7ve6Az
         caGaX7W60k1HO/uFSIqFQfMu3HSW9m4lrCSNH/K8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 10/71] ALSA: hda - Apply workaround for another AMD chip 1022:1487
Date:   Thu, 22 Aug 2019 10:18:45 -0700
Message-Id: <20190822171727.288966710@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit de768ce45466f3009809719eb7b1f6f5277d9373 upstream.

MSI MPG X570 board is with another AMD HD-audio controller (PCI ID
1022:1487) and it requires the same workaround applied for X370, etc
(PCI ID 1022:1457).

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=195303
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2577,6 +2577,9 @@ static const struct pci_device_id azx_id
 	/* AMD, X370 & co */
 	{ PCI_DEVICE(0x1022, 0x1457),
 	  .driver_data = AZX_DRIVER_GENERIC | AZX_DCAPS_PRESET_AMD_SB },
+	/* AMD, X570 & co */
+	{ PCI_DEVICE(0x1022, 0x1487),
+	  .driver_data = AZX_DRIVER_GENERIC | AZX_DCAPS_PRESET_AMD_SB },
 	/* AMD Stoney */
 	{ PCI_DEVICE(0x1022, 0x157a),
 	  .driver_data = AZX_DRIVER_GENERIC | AZX_DCAPS_PRESET_ATI_SB |


