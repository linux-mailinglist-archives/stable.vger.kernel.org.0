Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F3414557F
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbgAVNWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:22:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbgAVNWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:22:33 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D716A24690;
        Wed, 22 Jan 2020 13:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699352;
        bh=izB+U4VTqVzEqSWKIcuixLoto9qu8cWMY14h+CQf9gE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lv93rYi5vtu6azTf45mi75PZfsC8hPVBLYaHCEKUqjAvwo+dwincbWuDNtqY/aehm
         HOhwp7gemWcaMT+MCwDYdh2F6U114DuqUsODQKa6GJGbJLXVIN0jaubDTb7RXFBgvx
         3txxUNZ/+VXUgXC2Ogx6bFCO5UxFJnFmh5vWQRxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 119/222] cfg80211: fix memory leak in nl80211_probe_mesh_link
Date:   Wed, 22 Jan 2020 10:28:25 +0100
Message-Id: <20200122092842.260670992@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit 2a279b34169e9bbf7c240691466420aba75b4175 upstream.

The per-tid statistics need to be released after the call to rdev_get_station

Cc: stable@vger.kernel.org
Fixes: 5ab92e7fe49a ("cfg80211: add support to probe unexercised mesh link")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20200108170630.33680-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13787,6 +13787,8 @@ static int nl80211_probe_mesh_link(struc
 	if (err)
 		return err;
 
+	cfg80211_sinfo_release_content(&sinfo);
+
 	return rdev_probe_mesh_link(rdev, dev, dest, buf, len);
 }
 


