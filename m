Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E2130C8AE
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238010AbhBBR51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:57:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233943AbhBBOIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:08:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3381665026;
        Tue,  2 Feb 2021 13:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273811;
        bh=YmmVrfADKQPkGiEzioXk3a5THk9oy8tVCgLEMIEcB9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPWX3/wS5sMk1iGtgp7y0XP0KHg4AnRmLonvF99p/b8axwV4hD19xoSuBtELPZLQ0
         FXa8wfyF1rFEGDBfYSSNt34pKS8OjXIUbyKB74JptilLadaxAhqstxoM1oavp71p+O
         r0/SGPcWAthPyNkhFVgMJ89+8CPX7SWy1omi633w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+444248c79e117bc99f46@syzkaller.appspotmail.com,
        syzbot+8b2a88a09653d4084179@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.9 02/32] wext: fix NULL-ptr-dereference with cfg80211s lack of commit()
Date:   Tue,  2 Feb 2021 14:38:25 +0100
Message-Id: <20210202132942.133781388@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.035179752@linuxfoundation.org>
References: <20210202132942.035179752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 5122565188bae59d507d90a9a9fd2fd6107f4439 upstream.

Since cfg80211 doesn't implement commit, we never really cared about
that code there (and it's configured out w/o CONFIG_WIRELESS_EXT).
After all, since it has no commit, it shouldn't return -EIWCOMMIT to
indicate commit is needed.

However, EIWCOMMIT is actually an alias for EINPROGRESS, which _can_
happen if e.g. we try to change the frequency but we're already in
the process of connecting to some network, and drivers could return
that value (or even cfg80211 itself might).

This then causes us to crash because dev->wireless_handlers is NULL
but we try to check dev->wireless_handlers->standard[0].

Fix this by also checking dev->wireless_handlers. Also simplify the
code a little bit.

Cc: stable@vger.kernel.org
Reported-by: syzbot+444248c79e117bc99f46@syzkaller.appspotmail.com
Reported-by: syzbot+8b2a88a09653d4084179@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20210121171621.2076e4a37d5a.I5d9c72220fe7bb133fb718751da0180a57ecba4e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/wext-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -898,8 +898,9 @@ out:
 int call_commit_handler(struct net_device *dev)
 {
 #ifdef CONFIG_WIRELESS_EXT
-	if ((netif_running(dev)) &&
-	   (dev->wireless_handlers->standard[0] != NULL))
+	if (netif_running(dev) &&
+	    dev->wireless_handlers &&
+	    dev->wireless_handlers->standard[0])
 		/* Call the commit handler on the driver */
 		return dev->wireless_handlers->standard[0](dev, NULL,
 							   NULL, NULL);


