Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9544727F9
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237848AbhLMKGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241451AbhLMKEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:04:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E25AC09CE64;
        Mon, 13 Dec 2021 01:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 866E4CE0E80;
        Mon, 13 Dec 2021 09:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CA7C341CA;
        Mon, 13 Dec 2021 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389015;
        bh=jwKI3uDMqhGbXFFf1Z80wcLtoC7mvKfFvLkRUSjyeW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyNZHQiTPp1JTwxgJ9r47rN33AUvIpM08Y/jutuf+JcFxp7Q7hxm1j6EWaDLldCvS
         m8bXoYNzwtXKnq8sP1qIDUgTnIedC4oZ8xqhnjv7ham3teE/p2IQvyuKW1RPXM9SRD
         /bxXLv46bWyQeT5GkT1z8X8kRQw7Zs2EI3eTwI20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Young <consult.awy@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 045/132] ALSA: ctl: Fix copy of updated id with element read/write
Date:   Mon, 13 Dec 2021 10:29:46 +0100
Message-Id: <20211213092940.671456299@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
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
@@ -264,6 +264,7 @@ static int copy_ctl_value_to_user(void _
 				  struct snd_ctl_elem_value *data,
 				  int type, int count)
 {
+	struct snd_ctl_elem_value32 __user *data32 = userdata;
 	int i, size;
 
 	if (type == SNDRV_CTL_ELEM_TYPE_BOOLEAN ||
@@ -280,6 +281,8 @@ static int copy_ctl_value_to_user(void _
 		if (copy_to_user(valuep, data->value.bytes.data, size))
 			return -EFAULT;
 	}
+	if (copy_to_user(&data32->id, &data->id, sizeof(data32->id)))
+		return -EFAULT;
 	return 0;
 }
 


