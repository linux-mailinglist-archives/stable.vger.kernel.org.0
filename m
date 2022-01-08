Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C555488516
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 18:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiAHRqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 12:46:08 -0500
Received: from srvc114.turhost.com ([109.232.216.117]:46501 "EHLO
        srvc114.turhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiAHRqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jan 2022 12:46:08 -0500
X-Greylist: delayed 4084 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Jan 2022 12:46:07 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ercanersoy.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        Message-ID:Subject:Cc:To:From:Date:MIME-Version:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4cBGWbW/2vVBMWwmcH6zXysZAZyAqPv/AWVH04aU0LE=; b=P1gldOQRy72FHqiF8Xugi8O6TY
        AMZyYZyIoqTxPNsFgSBb5ku5EbXI6DHUz7fj5vsyOkibJ3cz8hWtdRqdmnY/lyHKoFGAKMkjwRHOV
        UdhpLmsNMnxlbfwFiKwxiLfyKFsZtN2l7BBM8594hbkfxiJz0XOqPkA3OyPeBHXiZP/attHBZdsRd
        SR7L5ngoYhjzc5LIXPveVgAsAYDq/6KdwL4SC0W4nbA+jQ0DqQxg5aHUutwg4yBWsISburDkcqqt5
        YmD8DeqEelGizoitYu0EB3PmYcrkwclfuVHc2cbyws2p9BZOQfhtOJEVVrPZ7dydXXYpUXb4PHAxF
        vQ2c/RJw==;
Received: from [::1] (port=51817 helo=srvc114.turhost.com)
        by srvc114.turhost.com with esmtpa (Exim 4.94.2)
        (envelope-from <ercanersoy@ercanersoy.net>)
        id 1n6Ej9-0066Sl-TX; Sat, 08 Jan 2022 19:38:00 +0300
MIME-Version: 1.0
Date:   Sat, 08 Jan 2022 19:37:59 +0300
From:   Ercan Ersoy <ercanersoy@ercanersoy.net>
To:     security@kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/1] Fix uninitialiazed variable bug
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <d796d15c3577a35a46e4feac7e6a9e85@ercanersoy.net>
X-Sender: ercanersoy@ercanersoy.net
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srvc114.turhost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ercanersoy.net
X-Get-Message-Sender-Via: srvc114.turhost.com: authenticated_id: ercanersoy@ercanersoy.net
X-Authenticated-Sender: srvc114.turhost.com: ercanersoy@ercanersoy.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This bug is in mem_cgroup_resize_max function
in mm/memcontrol.c source file.

Signed-off-by: Ercan Ersoy <ercanersoy@ercanersoy.net>
---
  mm/memcontrol.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2ed5f2a0879d..977f58b8f1e6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3351,7 +3351,7 @@ static int mem_cgroup_resize_max(struct mem_cgroup 
*memcg,
  {
         bool enlarge = false;
         bool drained = false;
-       int ret;
+       int ret = 0;
         bool limits_invariant;
         struct page_counter *counter = memsw ? &memcg->memsw : 
&memcg->memory;

-- 
2.30.2
