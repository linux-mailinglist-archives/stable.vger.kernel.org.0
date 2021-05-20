Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F3038A58E
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbhETKRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236509AbhETKP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:15:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98ACA6199C;
        Thu, 20 May 2021 09:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503948;
        bh=AQCgiZQKfDgZW64XvcUOoHXZf+lYBeOXQbgpMYOkqTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAc26GM3rLlFh4EpZc+kJowf/bLtJI9HwKOcGicIGawmU/1N5gFzRfRgxsaepgaM1
         zE0rGzYwmqlp/X+UHl5cxj2AyvOa9QPfiHXRV085ZazeKCYyraRldynmH30SbYYfMD
         gXpSu4E1wmspK0UzD06VsXno8C+HpvnV7AzgTRCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Langsdorf <mlangsdo@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 018/323] ACPI: custom_method: fix potential use-after-free issue
Date:   Thu, 20 May 2021 11:18:30 +0200
Message-Id: <20210520092120.739463648@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Langsdorf <mlangsdo@redhat.com>

commit e483bb9a991bdae29a0caa4b3a6d002c968f94aa upstream.

In cm_write(), buf is always freed when reaching the end of the
function.  If the requested count is less than table.length, the
allocated buffer will be freed but subsequent calls to cm_write() will
still try to access it.

Remove the unconditional kfree(buf) at the end of the function and
set the buf to NULL in the -EINVAL error path to match the rest of
function.

Fixes: 03d1571d9513 ("ACPI: custom_method: fix memory leaks")
Signed-off-by: Mark Langsdorf <mlangsdo@redhat.com>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/custom_method.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/custom_method.c
+++ b/drivers/acpi/custom_method.c
@@ -50,6 +50,7 @@ static ssize_t cm_write(struct file *fil
 	    (*ppos + count < count) ||
 	    (count > uncopied_bytes)) {
 		kfree(buf);
+		buf = NULL;
 		return -EINVAL;
 	}
 
@@ -71,7 +72,6 @@ static ssize_t cm_write(struct file *fil
 		add_taint(TAINT_OVERRIDDEN_ACPI_TABLE, LOCKDEP_NOW_UNRELIABLE);
 	}
 
-	kfree(buf);
 	return count;
 }
 


