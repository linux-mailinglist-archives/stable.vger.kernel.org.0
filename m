Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB53419BB6
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237129AbhI0RV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236849AbhI0RTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:19:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D357C61207;
        Mon, 27 Sep 2021 17:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762774;
        bh=jLCJhns9HTI4rMD7nvi9gKB9VSysCzapuFOzmrO6FsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBOopX1AJNDwGCRQO20NJi6hhr07kWKyJZo1A4ZzxRivYZz95ELBfGk/g9rD/HQ9d
         r2vtEpkU3sXAn/EyDqx8+CzLO4nKACS8E4E6AW6WzTRCmpsrE8J8jdg0h5hfZRkyAc
         4aVzan3xdjEW+DrnFlReZ72y9sAorUjKkOnrQSJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        linux-staging@lists.linux.dev, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.14 046/162] comedi: Fix memory leak in compat_insnlist()
Date:   Mon, 27 Sep 2021 19:01:32 +0200
Message-Id: <20210927170235.094133935@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit bb509a6ffed2c8b0950f637ab5779aa818ed1596 upstream.

`compat_insnlist()` handles the 32-bit version of the `COMEDI_INSNLIST`
ioctl (whenwhen `CONFIG_COMPAT` is enabled).  It allocates memory to
temporarily hold an array of `struct comedi_insn` converted from the
32-bit version in user space.  This memory is only being freed if there
is a fault while filling the array, otherwise it is leaked.

Add a call to `kfree()` to fix the leak.

Fixes: b8d47d881305 ("comedi: get rid of compat_alloc_user_space() mess in COMEDI_INSNLIST compat")
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-staging@lists.linux.dev
Cc: <stable@vger.kernel.org> # 5.13+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210916145023.157479-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/comedi_fops.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -3090,6 +3090,7 @@ static int compat_insnlist(struct file *
 	mutex_lock(&dev->mutex);
 	rc = do_insnlist_ioctl(dev, insns, insnlist32.n_insns, file);
 	mutex_unlock(&dev->mutex);
+	kfree(insns);
 	return rc;
 }
 


