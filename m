Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D07137E55
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbgAKKIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:08:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbgAKKIr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:08:47 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BB782064C;
        Sat, 11 Jan 2020 10:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737327;
        bh=QwCiPWsHROdyM6XfCtmVRetKjby4HK+y9x9ed/v9fuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aI7I0PxNjqd8nvN4bOAKz3aK3Tm4GW0kLgWldw4STJ59mjR7tStyuulFLFDCEpit/
         TEIcMh9SVvtNhtLecIa5XcNGg3CI3CoGYZvgPEY49gcokAE0mO2xlvMpin1hqA2LyH
         WiuG5hgFc6R+HspzSnl15ErC5MYq10RmwUe8lP80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudipm Mukherjee <sudipm.mukherjee@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/62] libtraceevent: Fix lib installation with O=
Date:   Sat, 11 Jan 2020 10:49:48 +0100
Message-Id: <20200111094840.134928601@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

[ Upstream commit 587db8ebdac2c5eb3a8851e16b26f2e2711ab797 ]

When we use 'O=' with make to build libtraceevent in a separate folder
it fails to install libtraceevent.a and libtraceevent.so.1.1.0 with the
error:

  INSTALL  /home/sudip/linux/obj-trace/libtraceevent.a
  INSTALL  /home/sudip/linux/obj-trace/libtraceevent.so.1.1.0

  cp: cannot stat 'libtraceevent.a': No such file or directory
  Makefile:225: recipe for target 'install_lib' failed
  make: *** [install_lib] Error 1

I used the command:

  make O=../../../obj-trace DESTDIR=~/test prefix==/usr  install

It turns out libtraceevent Makefile, even though it builds in a separate
folder, searches for libtraceevent.a and libtraceevent.so.1.1.0 in its
source folder.

So, add the 'OUTPUT' prefix to the source path so that 'make' looks for
the files in the correct place.

Signed-off-by: Sudipm Mukherjee <sudipm.mukherjee@gmail.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/lkml/20191115113610.21493-1-sudipm.mukherjee@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/traceevent/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 8107f060fa84..a0ac01c647f5 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -115,6 +115,7 @@ EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
 
 LIB_TARGET  = libtraceevent.a libtraceevent.so.$(EVENT_PARSE_VERSION)
 LIB_INSTALL = libtraceevent.a libtraceevent.so*
+LIB_INSTALL := $(addprefix $(OUTPUT),$(LIB_INSTALL))
 
 INCLUDES = -I. -I $(srctree)/tools/include $(CONFIG_INCLUDES)
 
-- 
2.20.1



