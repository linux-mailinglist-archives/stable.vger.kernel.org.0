Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488D633B8D1
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhCOOEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233019AbhCOOAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 765D164D9E;
        Mon, 15 Mar 2021 14:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816812;
        bh=u05QLZmcL9GGMe5D8tEnIMmyh9DU6uRxx+Tp8Cvl9Dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w8ay2KIem76McBWVhd6DaTRlLeGC5b3PCeQzx2L25NCGvXZauFb52iBXKgitw+yHL
         76mL/IkqrNlIpNdlh/P7fFJC6l1Wl8T1Zf0NKuWbFMXCaq9bZfEnGM3fLQXSBBXKTM
         UbGw7r8/hCZmgivM9TjWjPmNR6z4bK4Un7vw8Irk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.14 80/95] staging: comedi: pcl818: Fix endian problem for AI command data
Date:   Mon, 15 Mar 2021 14:57:50 +0100
Message-Id: <20210315135742.908401983@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ian Abbott <abbotti@mev.co.uk>

commit 148e34fd33d53740642db523724226de14ee5281 upstream.

The analog input subdevice supports Comedi asynchronous commands that
use Comedi's 16-bit sample format.  However, the call to
`comedi_buf_write_samples()` is passing the address of a 32-bit integer
parameter.  On bigendian machines, this will copy 2 bytes from the wrong
end of the 32-bit value.  Fix it by changing the type of the parameter
holding the sample value to `unsigned short`.

[Note: the bug was introduced in commit edf4537bcbf5 ("staging: comedi:
pcl818: use comedi_buf_write_samples()") but the patch applies better to
commit d615416de615 ("staging: comedi: pcl818: introduce
pcl818_ai_write_sample()").]

Fixes: d615416de615 ("staging: comedi: pcl818: introduce pcl818_ai_write_sample()")
Cc: <stable@vger.kernel.org> # 4.0+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210223143055.257402-10-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/pcl818.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -422,7 +422,7 @@ static int pcl818_ai_eoc(struct comedi_d
 
 static bool pcl818_ai_write_sample(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
-				   unsigned int chan, unsigned int val)
+				   unsigned int chan, unsigned short val)
 {
 	struct pcl818_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;


