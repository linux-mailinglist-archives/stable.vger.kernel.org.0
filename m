Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A8F99B31
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391315AbfHVRW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:22:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391306AbfHVRW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:26 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B05612341C;
        Thu, 22 Aug 2019 17:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494545;
        bh=X42x0xK8Yv7JFdRdm38qmeC5UC56ygSVuWr4FXYQzcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yHwnYsLnnvAqIDxnAmiuf5XlA3xyE0Hkxs5FI2zJvPon2V7HgigsErUHQwVgBBKVx
         NTZX8xLu9jc5lQTrMG3EzqxbWqbYfsT6uA+nU9b+TzLsnBv213mCQfvbheikvowkEx
         f/b0Q0FVnwDYB3ocDZZ43cN2vuq5cy3gltZf6xhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 27/78] ALSA: firewire: fix a memory leak bug
Date:   Thu, 22 Aug 2019 10:18:31 -0700
Message-Id: <20190822171832.829168990@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

commit 1be3c1fae6c1e1f5bb982b255d2034034454527a upstream.

In iso_packets_buffer_init(), 'b->packets' is allocated through
kmalloc_array(). Then, the aligned packet size is checked. If it is
larger than PAGE_SIZE, -EINVAL will be returned to indicate the error.
However, the allocated 'b->packets' is not deallocated on this path,
leading to a memory leak.

To fix the above issue, free 'b->packets' before returning the error code.

Fixes: 31ef9134eb52 ("ALSA: add LaCie FireWire Speakers/Griffin FireWave Surround driver")
Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: <stable@vger.kernel.org> # v2.6.39+
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/packets-buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/firewire/packets-buffer.c
+++ b/sound/firewire/packets-buffer.c
@@ -37,7 +37,7 @@ int iso_packets_buffer_init(struct iso_p
 	packets_per_page = PAGE_SIZE / packet_size;
 	if (WARN_ON(!packets_per_page)) {
 		err = -EINVAL;
-		goto error;
+		goto err_packets;
 	}
 	pages = DIV_ROUND_UP(count, packets_per_page);
 


