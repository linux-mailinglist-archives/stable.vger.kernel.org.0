Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA53C4723DA
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhLMJcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:32:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46228 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbhLMJcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:32:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 127BAB80DE8;
        Mon, 13 Dec 2021 09:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B90CC00446;
        Mon, 13 Dec 2021 09:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639387937;
        bh=txRjvqdPoP9bXfWGgH14tGapvUXAwE0Jl0sRvtiVegU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EC1terjZMd+T7fWGXcTBjvHqe79G0Xmme5AqQZX5Vbdi0HSMHXdmLXOYhuZ/6oZaP
         f36vxIMCAvJEjCCAE3sAE2yslyD6DOGFwKAoA9kzYFa8LkLohSMDtDF6B9EGi8QTp2
         x/xJSq8deFlvUC06bpo4Hsn1uIiwAXCPfoSx6kAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Young <consult.awy@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 11/37] ALSA: ctl: Fix copy of updated id with element read/write
Date:   Mon, 13 Dec 2021 10:29:49 +0100
Message-Id: <20211213092925.740672958@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092925.380184671@linuxfoundation.org>
References: <20211213092925.380184671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Young <consult.awy@gmail.com>

commit b6409dd6bdc03aa178bbff0d80db2a30d29b63ac upstream.

When control_compat.c:copy_ctl_value_to_user() is used, by
ctl_elem_read_user() & ctl_elem_write_user(), it must also copy back the
snd_ctl_elem_id value that may have been updated (filled in) by the call
to snd_ctl_elem_read/snd_ctl_elem_write().

This matches the functionality provided by snd_ctl_elem_read_user() and
snd_ctl_elem_write_user(), via snd_ctl_build_ioff().

Without this, and without making additional calls to snd_ctl_info()
which are unnecessary when using the non-compat calls, a userspace
application will not know the numid value for the element and
consequently will not be able to use the poll/read interface on the
control file to determine which elements have updates.

Signed-off-by: Alan Young <consult.awy@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211202150607.543389-1-consult.awy@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/control_compat.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/core/control_compat.c
+++ b/sound/core/control_compat.c
@@ -281,6 +281,7 @@ static int copy_ctl_value_to_user(void _
 				  struct snd_ctl_elem_value *data,
 				  int type, int count)
 {
+	struct snd_ctl_elem_value32 __user *data32 = userdata;
 	int i, size;
 
 	if (type == SNDRV_CTL_ELEM_TYPE_BOOLEAN ||
@@ -297,6 +298,8 @@ static int copy_ctl_value_to_user(void _
 		if (copy_to_user(valuep, data->value.bytes.data, size))
 			return -EFAULT;
 	}
+	if (copy_to_user(&data32->id, &data->id, sizeof(data32->id)))
+		return -EFAULT;
 	return 0;
 }
 


