Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F1C137EEF
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgAKKPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:15:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730076AbgAKKPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:15:05 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 802BD20848;
        Sat, 11 Jan 2020 10:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737705;
        bh=rAMFqApMQxwITHsnu5Pg7D3xR8Q9/+Cve3z8RndOyT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=peehkEUa5xYDB+E0Xl6TDK+YIEio3R2s5O7V/QJKuQgyzicHs1JO+iwUXgWLnlYLj
         AHGT8K0B2fKE+X4WwTagd/34lJJAgWtL6xMlojpHQTHcC9H/YgYDiAOxsbqkvpb70x
         RSK+FaT7ptSGgRXZ9xBl3TAwPpXz3x2DRzgxstd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudipm Mukherjee <sudipm.mukherjee@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/84] libtraceevent: Fix lib installation with O=
Date:   Sat, 11 Jan 2020 10:49:46 +0100
Message-Id: <20200111094847.691878589@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
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
index bca0c9e5452c..05f8a0f27121 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -115,6 +115,7 @@ EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
 
 LIB_TARGET  = libtraceevent.a libtraceevent.so.$(EVENT_PARSE_VERSION)
 LIB_INSTALL = libtraceevent.a libtraceevent.so*
+LIB_INSTALL := $(addprefix $(OUTPUT),$(LIB_INSTALL))
 
 INCLUDES = -I. -I $(srctree)/tools/include $(CONFIG_INCLUDES)
 
-- 
2.20.1



