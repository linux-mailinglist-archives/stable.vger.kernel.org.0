Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7EE20DEF2
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732538AbgF2Ua6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732480AbgF2TZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C832125407;
        Mon, 29 Jun 2020 15:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445353;
        bh=FLR1irznMZBpSrXbVAb2w1UYt1EZwIZZD5ToCoTJKu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znryeguIViFHtsxKiUGIHWP5tfJ6s0JVhn/RTIfPGXLyp4ba5lOerVkPTCt29uyW0
         SlKdVgk1/25/lxDMoHi2Ro8Be0ATDO5rEQmFWdUMUdRNV8qYNQRKT1joUOHHRfBJ/M
         T5WYluhPfpfoCFZcWB0pyfis0A3ymJYttv5Uli58=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 111/191] media: dvb_frontend: fix return values for FE_SET_PROPERTY
Date:   Mon, 29 Jun 2020 11:38:47 -0400
Message-Id: <20200629154007.2495120-112-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit 259a41d9ae8f3689742267f340ad2b159d00b302 upstream

There are several problems with regards to the return of
FE_SET_PROPERTY. The original idea were to return per-property
return codes via tvp->result field, and to return an updated
set of values.

However, that never worked. What's actually implemented is:

- the FE_SET_PROPERTY implementation doesn't call .get_frontend
  callback in order to get the actual parameters after return;

- the tvp->result field is only filled if there's no error.
  So, it is always filled with zero;

- FE_SET_PROPERTY doesn't call memdup_user() nor any other
  copy_to_user() function. So, any changes to the properties
  will be lost;

- FE_SET_PROPERTY is declared as a write-only ioctl (IOW).

While we could fix the above, it could cause regressions.

So, let's just assume what the code really does, updating
the documentation accordingly and removing the logic that
would update the discarded tvp->result.

Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/media/uapi/dvb/fe-get-property.rst | 7 +++++--
 drivers/media/dvb-core/dvb_frontend.c            | 2 --
 include/uapi/linux/dvb/frontend.h                | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/uapi/dvb/fe-get-property.rst b/Documentation/media/uapi/dvb/fe-get-property.rst
index 015d4db597b58..c80c5fc6e9163 100644
--- a/Documentation/media/uapi/dvb/fe-get-property.rst
+++ b/Documentation/media/uapi/dvb/fe-get-property.rst
@@ -48,8 +48,11 @@ depends on the delivery system and on the device:
 
    -  This call requires read/write access to the device.
 
-   -  At return, the values are updated to reflect the actual parameters
-      used.
+.. note::
+
+   At return, the values aren't updated to reflect the actual
+   parameters used. If the actual parameters are needed, an explicit
+   call to ``FE_GET_PROPERTY`` is needed.
 
 -  ``FE_GET_PROPERTY:``
 
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 673cefb7230cb..ca4959bbb6c2f 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2127,7 +2127,6 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 				kfree(tvp);
 				return err;
 			}
-			(tvp + i)->result = err;
 		}
 		kfree(tvp);
 		break;
@@ -2172,7 +2171,6 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 				kfree(tvp);
 				return err;
 			}
-			(tvp + i)->result = err;
 		}
 
 		if (copy_to_user((void __user *)tvps->props, tvp,
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 16a318fc469a8..b653754ee9cfa 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -830,7 +830,7 @@ struct dtv_fe_stats {
  * @cmd:	Digital TV command.
  * @reserved:	Not used.
  * @u:		Union with the values for the command.
- * @result:	Result of the command set (currently unused).
+ * @result:	Unused
  *
  * The @u union may have either one of the values below:
  *
-- 
2.25.1

