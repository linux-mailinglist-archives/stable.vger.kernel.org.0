Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8EAD8DAAC
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730103AbfHNRL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730591AbfHNRLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:11:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B968A2084D;
        Wed, 14 Aug 2019 17:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802682;
        bh=X42x0xK8Yv7JFdRdm38qmeC5UC56ygSVuWr4FXYQzcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7rAcOe8mZKV+DFor7H+Cz9XItXEBcoRdm1+1bCtknaQn4r4WdMB5l1MtX4JbnZZ+
         j+yhQHkzk8tUTgsN7kmWl+OInKDVMqexYTLLgJcik81n7hn663wDrj9T4pKxgabgXr
         cTCZhqKh3a3y6oSR4SIP0KLP4Oap25h8sBP9I8As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 77/91] ALSA: firewire: fix a memory leak bug
Date:   Wed, 14 Aug 2019 19:01:40 +0200
Message-Id: <20190814165753.092767557@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
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
 


