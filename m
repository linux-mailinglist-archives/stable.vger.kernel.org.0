Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963E1395F92
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhEaOM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:12:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232964AbhEaOK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:10:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06E976197E;
        Mon, 31 May 2021 13:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468454;
        bh=ho8wNsWodGV8XUdzJfKNfzNnuCbo3ugXe/yK1a6pLyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mfmmq4YQ8SAMsTofxShQ5oCo4jNG5SwECSTx+L9ufax4qGjLkuGh5SlTsSatlOvU2
         t98ZYxAFzhEtq40DHAplX5pFjHKd5f6LRu7EcbdL54MM9zhbg8B2GbbCTZV0Q/fqEl
         W6GWmMrj+hkg3srGDl8tEELHOnWnlgtjpX/Spqrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 248/252] Revert "Revert "ALSA: usx2y: Fix potential NULL pointer dereference""
Date:   Mon, 31 May 2021 15:15:13 +0200
Message-Id: <20210531130706.422623619@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 27b57bb76a897be80494ee11ee4e85326d19383d upstream.

This reverts commit 4667a6fc1777ce071504bab570d3599107f4790f.

Takashi writes:
	I have already started working on the bigger cleanup of this driver
	code based on 5.13-rc1, so could you drop this revert?

I missed our previous discussion about this, my fault for applying it.

Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/usx2y/usb_stream.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/usb/usx2y/usb_stream.c
+++ b/sound/usb/usx2y/usb_stream.c
@@ -91,7 +91,12 @@ static int init_urbs(struct usb_stream_k
 
 	for (u = 0; u < USB_STREAM_NURBS; ++u) {
 		sk->inurb[u] = usb_alloc_urb(sk->n_o_ps, GFP_KERNEL);
+		if (!sk->inurb[u])
+			return -ENOMEM;
+
 		sk->outurb[u] = usb_alloc_urb(sk->n_o_ps, GFP_KERNEL);
+		if (!sk->outurb[u])
+			return -ENOMEM;
 	}
 
 	if (init_pipe_urbs(sk, use_packsize, sk->inurb, indata, dev, in_pipe) ||


