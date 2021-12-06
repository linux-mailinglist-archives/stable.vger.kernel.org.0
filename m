Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B577469E3A
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346251AbhLFPhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:37:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37350 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388344AbhLFPcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:32:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21482B8111C;
        Mon,  6 Dec 2021 15:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44622C34900;
        Mon,  6 Dec 2021 15:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804545;
        bh=jvzNmJK63+tjJYtDhzEY6ibaTayFSQtHZM1E31RcI/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JeUoC3z1PiEK6Z7Bv3f8X3pbCegMFyB1IJeAzF6mEk1KkS8++t4McCVXk2KPZiDeB
         NJHXsATA7cmwsYk0xsX+yF9mUDj/aUNbRhdWhZ2tBuhGtjDTJgMbCJejNRQqMrlJAS
         K9TYRc3uiqJeRsH/gNbCErv+ipWWo71hQAS60rUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 186/207] parisc: Fix "make install" on newer debian releases
Date:   Mon,  6 Dec 2021 15:57:20 +0100
Message-Id: <20211206145616.714634694@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 0f9fee4cdebfbe695c297e5b603a275e2557c1cc upstream.

On newer debian releases the debian-provided "installkernel" script is
installed in /usr/sbin. Fix the kernel install.sh script to look for the
script in this directory as well.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v3.13+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/install.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/install.sh
+++ b/arch/parisc/install.sh
@@ -39,6 +39,7 @@ verify "$3"
 if [ -n "${INSTALLKERNEL}" ]; then
   if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
   if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
+  if [ -x /usr/sbin/${INSTALLKERNEL} ]; then exec /usr/sbin/${INSTALLKERNEL} "$@"; fi
 fi
 
 # Default install


