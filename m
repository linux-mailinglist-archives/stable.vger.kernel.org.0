Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 484CD7969F
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390903AbfG2Txd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:53:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390679AbfG2Txd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:53:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5F5D2171F;
        Mon, 29 Jul 2019 19:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430012;
        bh=g3Qa5pRkKnZVNZExxBrPTdWu2N5wP1p8syJV2zVv3rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGtXggJOnZiW5nynnQdPuGYzpymwjDuZv5331rYrtDNVHKLj3XJOJKxEWr3WTKHln
         6GUJomXWWIgqP3WOb4VvJWBbK5g+E8hAw85bymE7jDrJSprzQVOnWAiiVz3Q4lryFu
         2UGqRAz4kWCPvOMUcjwFHgfTT30+SjGx0j9p4EPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+fd2bd7df88c606eea4ef@syzkaller.appspotmail.com,
        Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH 5.2 169/215] usb: wusbcore: fix unbalanced get/put cluster_id
Date:   Mon, 29 Jul 2019 21:22:45 +0200
Message-Id: <20190729190809.186902009@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phong Tran <tranmanphong@gmail.com>

commit f90bf1ece48a736097ea224430578fe586a9544c upstream.

syzboot reported that
https://syzkaller.appspot.com/bug?extid=fd2bd7df88c606eea4ef

There is not consitency parameter in cluste_id_get/put calling.
In case of getting the id with result is failure, the wusbhc->cluster_id
will not be updated and this can not be used for wusb_cluster_id_put().

Tested report
https://groups.google.com/d/msg/syzkaller-bugs/0znZopp3-9k/oxOrhLkLEgAJ

Reproduce and gdb got the details:

139		addr = wusb_cluster_id_get();
(gdb) n
140		if (addr == 0)
(gdb) print addr
$1 = 254 '\376'
(gdb) n
142		result = __hwahc_set_cluster_id(hwahc, addr);
(gdb) print result
$2 = -71
(gdb) break wusb_cluster_id_put
Breakpoint 3 at 0xffffffff836e3f20: file drivers/usb/wusbcore/wusbhc.c, line 384.
(gdb) s
Thread 2 hit Breakpoint 3, wusb_cluster_id_put (id=0 '\000') at drivers/usb/wusbcore/wusbhc.c:384
384		id = 0xff - id;
(gdb) n
385		BUG_ON(id >= CLUSTER_IDS);
(gdb) print id
$3 = 255 '\377'

Reported-by: syzbot+fd2bd7df88c606eea4ef@syzkaller.appspotmail.com
Signed-off-by: Phong Tran <tranmanphong@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190724020601.15257-1-tranmanphong@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/hwa-hc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/hwa-hc.c
+++ b/drivers/usb/host/hwa-hc.c
@@ -159,7 +159,7 @@ out:
 	return result;
 
 error_set_cluster_id:
-	wusb_cluster_id_put(wusbhc->cluster_id);
+	wusb_cluster_id_put(addr);
 error_cluster_id_get:
 	goto out;
 


