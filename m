Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF27134C0F
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgAHTtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:49:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43466 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730417AbgAHTqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:02 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-0006o6-52; Wed, 08 Jan 2020 19:45:58 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-007dlj-Gd; Wed, 08 Jan 2020 19:45:57 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Wolfram Sang" <wsa@the-dreams.de>,
        "Michal Marek" <mmarek@suse.com>
Date:   Wed, 08 Jan 2020 19:43:14 +0000
Message-ID: <lsq.1578512578.201161676@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 16/63] kbuild: setlocalversion: print error to STDERR
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa@the-dreams.de>

commit 78283edf2c01c38eb840a3de5ffd18fe2992ab64 upstream.

I tried to use 'make O=...' from an unclean source tree. This triggered
the error path of setlocalversion. But by printing to STDOUT, it created
a broken localversion which then caused another (unrelated) error:

"4.7.0-rc2Error: kernelrelease not valid - run make prepare to update it" exceeds 64 characters

After printing to STDERR, the true build error gets displayed later:

  /home/wsa/Kernel/linux is not clean, please run 'make mrproper'
  in the '/home/wsa/Kernel/linux' directory.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Michal Marek <mmarek@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 scripts/setlocalversion | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -143,7 +143,7 @@ fi
 if test -e include/config/auto.conf; then
 	. include/config/auto.conf
 else
-	echo "Error: kernelrelease not valid - run 'make prepare' to update it"
+	echo "Error: kernelrelease not valid - run 'make prepare' to update it" >&2
 	exit 1
 fi
 

