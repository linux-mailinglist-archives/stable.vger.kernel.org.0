Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFBF39BF91
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 20:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhFDS2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 14:28:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229769AbhFDS2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 14:28:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96B83613F1;
        Fri,  4 Jun 2021 18:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622831186;
        bh=KkD73lZlvY+2766TT76oYNAWAxBI0JtHJdRPjOQRJJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bsYfquDze961jtKiN3j/X925lEMoZ8WqWHGtnik42LDWf/iuZoWlRcqW6WRRr+lIV
         0KUtCYof2kCxWZHB3MkiSNVEoSh3KMTk4Uv1B/sh3jn7hNP2iFOYc14z8+E6sb/xsV
         OMYu2tr+cHoVIjugLW+I2arjYsuc2C3LDlSC5065Vtxv9tUWNCFVoQUGxZgMMozGZp
         fLFZhoJNQGQGej9aU0ukemza7fLi+BXLEUM+H9lXj8EEMKkf8Eo9Zh0wmHEF2ZfsLY
         UAK1mh2loAFK5qJae0wqcba30fTZV6ANa+BVtxERH91lp1P2mwaPNT5IEKjUOxPIFy
         zQ+WJhPShhGhQ==
Date:   Fri, 4 Jun 2021 14:26:25 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        groeck@chromium.org, anant.thazhemadam@gmail.com,
        johannes.berg@intel.com
Subject: Re: [v5.4.y,v4.19.y] nl80211: validate key indexes for
 cfg80211_registered_device
Message-ID: <YLpwUeZSEBOZitfd@sashalap>
References: <20210603162852.1814513-1-zsm@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210603162852.1814513-1-zsm@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 03, 2021 at 09:28:52AM -0700, Zubin Mithra wrote:
>From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
>
>commit 2d9463083ce92636a1bdd3e30d1236e3e95d859e upstream
>
>syzbot discovered a bug in which an OOB access was being made because
>an unsuitable key_idx value was wrongly considered to be acceptable
>while deleting a key in nl80211_del_key().
>
>Since we don't know the cipher at the time of deletion, if
>cfg80211_validate_key_settings() were to be called directly in
>nl80211_del_key(), even valid keys would be wrongly determined invalid,
>and deletion wouldn't occur correctly.
>For this reason, a new function - cfg80211_valid_key_idx(), has been
>created, to determine if the key_idx value provided is valid or not.
>cfg80211_valid_key_idx() is directly called in 2 places -
>nl80211_del_key(), and cfg80211_validate_key_settings().
>
>Reported-by: syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
>Tested-by: syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
>Suggested-by: Johannes Berg <johannes@sipsolutions.net>
>Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
>Link: https://lore.kernel.org/r/20201204215825.129879-1-anant.thazhemadam@gmail.com
>Cc: stable@vger.kernel.org
>[also disallow IGTK key IDs if no IGTK cipher is supported]
>Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>Signed-off-by: Zubin Mithra <zsm@chromium.org>

Queued up, thanks!

-- 
Thanks,
Sasha
