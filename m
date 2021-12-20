Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4949347ACE6
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbhLTOrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:47:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38170 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237229AbhLTOpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:45:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60D6C6119F;
        Mon, 20 Dec 2021 14:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413EBC36AE8;
        Mon, 20 Dec 2021 14:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011532;
        bh=Xc/AEN8WTA05SmDzLo8kkkSgsDBsr5YxmqCafTeXtXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pig1u9hIsupntpQopP7a6IDhmXWfMfCY3ednyCtGNbJNhJC5Hrm9DLqQiI5UbbCrH
         7LlQODGz0W3AqKJ0kx+jhGgxbXUxfcsQeL7RSV9ErLAZ+upIovrYdKzE4uS72pSegL
         cflH5WTmemTdnqL//4N0Cy4MQTSv93EltPTAHc60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+59bdff68edce82e393b6@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 54/71] mac80211: validate extended element ID is present
Date:   Mon, 20 Dec 2021 15:34:43 +0100
Message-Id: <20211220143027.502024193@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 768c0b19b50665e337c96858aa2b7928d6dcf756 upstream.

Before attempting to parse an extended element, verify that
the extended element ID is present.

Fixes: 41cbb0f5a295 ("mac80211: add support for HE")
Reported-by: syzbot+59bdff68edce82e393b6@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20211211201023.f30a1b128c07.I5cacc176da94ba316877c6e10fe3ceec8b4dbd7d@changeid
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/util.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1227,6 +1227,8 @@ _ieee802_11_parse_elems_crc(const u8 *st
 				elems->max_idle_period_ie = (void *)pos;
 			break;
 		case WLAN_EID_EXTENSION:
+			if (!elen)
+				break;
 			if (pos[0] == WLAN_EID_EXT_HE_MU_EDCA &&
 			    elen >= (sizeof(*elems->mu_edca_param_set) + 1)) {
 				elems->mu_edca_param_set = (void *)&pos[1];


