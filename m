Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642E9472586
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbhLMJoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235628AbhLMJmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:42:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC609C07E5DD;
        Mon, 13 Dec 2021 01:39:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 34296CE0E86;
        Mon, 13 Dec 2021 09:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D6BC341C5;
        Mon, 13 Dec 2021 09:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388363;
        bh=64XQJ+4xT9Mu/GV6I7cuNv3zbxMky7x/azF2qytV56c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YDIWZCr8Cm/JuMlIs07SYxt3ivSmsb267QrET4x8SdzbWWxn3Fpo+/jL4nbro51Qz
         fws+Y63XII8eOayvm85ihqb/WeRcVT6OrLQoLlFtPOipgMUSVPoidZIYYVXfxWPVlM
         Cme4lzrn6lHB8EQRrgD/dpRDoKluyEticIJJgGjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 4.19 03/74] HID: add USB_HID dependancy to hid-prodikeys
Date:   Mon, 13 Dec 2021 10:29:34 +0100
Message-Id: <20211213092930.886079347@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 30cb3c2ad24b66fb7639a6d1f4390c74d6e68f94 upstream.

The prodikeys HID driver only controls USB devices, yet did not have a
dependancy on USB_HID.  This causes build errors on some configurations
like nios2 when building due to new changes to the prodikeys driver.

Reported-by: kernel test robot <lkp@intel.com>
Cc: stable@vger.kernel.org
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20211203081231.2856936-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -219,7 +219,7 @@ config HID_COUGAR
 
 config HID_PRODIKEYS
 	tristate "Prodikeys PC-MIDI Keyboard support"
-	depends on HID && SND
+	depends on USB_HID && SND
 	select SND_RAWMIDI
 	---help---
 	Support for Prodikeys PC-MIDI Keyboard device support.


