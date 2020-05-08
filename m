Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167581CAAE9
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgEHMiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:38:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728300AbgEHMiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DC26207DD;
        Fri,  8 May 2020 12:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941481;
        bh=yKbj0rJYXNByAGAysaCB5cEhbLfEKxdcr1mvomYSmG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aN+Z6em/+gsNQJPiCQ0GNpRh5RX0VNJ6sIuCy5YaSu6FoZ4jLRswTLlv3Vma9EDYb
         srEFEth9IkpRXXuEyhhhsnphPea/oGw5EB4NCH8TXkXjNbOO/oJtQjI5q8UenULgd1
         8r2spbvmGn7DNd92C8fQJuLdp5s5F8yK4HQOx2iE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 048/312] ALSA: fm801: explicitly free IRQ line
Date:   Fri,  8 May 2020 14:30:39 +0200
Message-Id: <20200508123127.933997624@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e97e98c63b43040732ad5d1f0b38ad4a8371c73a upstream.

Otherwise we will have a warning on ->remove() since device is a PCI one.

WARNING: CPU: 4 PID: 1411 at /home/andy/prj/linux/fs/proc/generic.c:575 remove_proc_entry+0x137/0x160()
remove_proc_entry: removing non-empty directory 'irq/21', leaking at least 'snd_fm801'

Fixes: 5618955c4269 (ALSA: fm801: move to pcim_* and devm_* functions)
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/fm801.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -1173,6 +1173,8 @@ static int snd_fm801_free(struct fm801 *
 	cmdw |= 0x00c3;
 	fm801_writew(chip, IRQ_MASK, cmdw);
 
+	devm_free_irq(&chip->pci->dev, chip->irq, chip);
+
       __end_hw:
 #ifdef CONFIG_SND_FM801_TEA575X_BOOL
 	if (!(chip->tea575x_tuner & TUNER_DISABLED)) {


