Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7AA4724A8
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbhLMJhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbhLMJg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:36:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954A7C0613F8;
        Mon, 13 Dec 2021 01:36:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E23B0CE0E82;
        Mon, 13 Dec 2021 09:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906DCC341C5;
        Mon, 13 Dec 2021 09:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388179;
        bh=fWchdcSIpbNAREqcECfxi337wWpII1DZOZmkczHDfKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmNb2Qzlkv/+Jzbk4GO/mOJ8xi+oUkbKL76pcv8dEHqtZx/bGBWqs/mTcQzGAPgnG
         KOXx0PFl13AipItwyRwWDe1YG4QH3ymllP1pT2MAMV57sJAWUhZb065YtTBBHSDLoY
         LYR+dtuZF/lmAfzpP6iv7ZhYbXaYB6NWJQsqUwZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Young <consult.awy@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 14/53] ALSA: ctl: Fix copy of updated id with element read/write
Date:   Mon, 13 Dec 2021 10:29:53 +0100
Message-Id: <20211213092928.835441252@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092928.349556070@linuxfoundation.org>
References: <20211213092928.349556070@linuxfoundation.org>
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
@@ -279,6 +279,7 @@ static int copy_ctl_value_to_user(void _
 				  struct snd_ctl_elem_value *data,
 				  int type, int count)
 {
+	struct snd_ctl_elem_value32 __user *data32 = userdata;
 	int i, size;
 
 	if (type == SNDRV_CTL_ELEM_TYPE_BOOLEAN ||
@@ -295,6 +296,8 @@ static int copy_ctl_value_to_user(void _
 		if (copy_to_user(valuep, data->value.bytes.data, size))
 			return -EFAULT;
 	}
+	if (copy_to_user(&data32->id, &data->id, sizeof(data32->id)))
+		return -EFAULT;
 	return 0;
 }
 


