Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9240A441831
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbhKAJpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhKAJnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:43:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75AE96139D;
        Mon,  1 Nov 2021 09:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758942;
        bh=9g/RVMqCKCYsmHZgYuQhLhr6c/CRsZfO74101G/VfAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Psr8cQC5W8xZaRS4fFQi0ZLr/WxuBEyMs0QCclynWnhx+elo1/IsNzGe2kdC8KQak
         OSBgP1Oc0Tld+ynRJhG6XFY7gBUtCrlnXYj946r4ov1OzmisVVKmSfl85MiIeAfT7U
         qUxYOF1X9N8fkDn0OXOOS2j64enmRWRDvTbIAP+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thelford Williams <tdwilliamsiv@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 048/125] drm/amdgpu: fix out of bounds write
Date:   Mon,  1 Nov 2021 10:17:01 +0100
Message-Id: <20211101082542.281324405@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thelford Williams <tdwilliamsiv@gmail.com>

commit 5afa7898ab7a0ec9c28556a91df714bf3c2f725e upstream.

Size can be any value and is user controlled resulting in overwriting the
40 byte array wr_buf with an arbitrary length of data from buf.

Signed-off-by: Thelford Williams <tdwilliamsiv@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -263,7 +263,7 @@ static ssize_t dp_link_settings_write(st
 	if (!wr_buf)
 		return -ENOSPC;
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 					   (long *)param, buf,
 					   max_param_num,
 					   &param_nums)) {


