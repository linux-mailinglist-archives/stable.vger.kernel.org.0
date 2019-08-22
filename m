Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD2A99D64
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391716AbfHVRmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390427AbfHVRXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:50 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C63BA2342A;
        Thu, 22 Aug 2019 17:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494629;
        bh=7MolTu/QaV4G78Ol8wsTvSGUS5eZKY0VigIqvUjN41o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQbgD27CYT+Qe3xxQjeUKa6DtHEPKPfaI5QTarIxxNb3TlFpR++3YfiyBuXZHEJxs
         rNyihPz7Greip9I9Y6oVO2QqEYIX4lFPQzdZ1Hz3rxf87JKcNlmMEAo8NTyxtOrXZN
         Sfx/LpGG8f4WZpKfejYRH3KGHlubcWQryQI/7GtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 061/103] ALSA: hda - Let all conexant codec enter D3 when rebooting
Date:   Thu, 22 Aug 2019 10:18:49 -0700
Message-Id: <20190822171731.258616541@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 401714d9534aad8c24196b32600da683116bbe09 upstream.

We have 3 new lenovo laptops which have conexant codec 0x14f11f86,
these 3 laptops also have the noise issue when rebooting, after
letting the codec enter D3 before rebooting or poweroff, the noise
disappers.

Instead of adding a new ID again in the reboot_notify(), let us make
this function apply to all conexant codec. In theory make codec enter
D3 before rebooting or poweroff is harmless, and I tested this change
on a couple of other Lenovo laptops which have different conexant
codecs, there is no side effect so far.

Cc: stable@vger.kernel.org
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -204,15 +204,6 @@ static void cx_auto_reboot_notify(struct
 {
 	struct conexant_spec *spec = codec->spec;
 
-	switch (codec->core.vendor_id) {
-	case 0x14f12008: /* CX8200 */
-	case 0x14f150f2: /* CX20722 */
-	case 0x14f150f4: /* CX20724 */
-		break;
-	default:
-		return;
-	}
-
 	/* Turn the problematic codec into D3 to avoid spurious noises
 	   from the internal speaker during (and after) reboot */
 	cx_auto_turn_eapd(codec, spec->num_eapds, spec->eapds, false);


