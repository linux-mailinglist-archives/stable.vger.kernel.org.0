Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0740B3291C4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242373AbhCAUcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:32:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242769AbhCAUZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:25:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C66564E4A;
        Mon,  1 Mar 2021 18:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621988;
        bh=NI1VjzaiF6azZhJTTL0bl/6LBhyzSq1jQIlavdfc2Dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wefWDm7IUnmi7WEGTMlh22+GVXrJCV1Qu/comVJVtegnmJ0ZVgJafRCc76ze/Hm1c
         jWNNmCo1hdTiwVY87e8sOeD/OD8F+HyywHtK0UrIpoF5sA8AJt2DyvWcQ0TblS7zUF
         htHeMRFHAD8xxM0GzskWOAEFcSlKh2DjFo1PX7QQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.11 716/775] mei: bus: block send with vtag on non-conformat FW
Date:   Mon,  1 Mar 2021 17:14:44 +0100
Message-Id: <20210301161236.729377007@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit b398d53cd421454d64850f8b1f6d609ede9042d9 upstream.

Block data send with vtag if either transport layer or
FW client are not supporting vtags.

Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210208150649.141358-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/bus.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -60,6 +60,13 @@ ssize_t __mei_cl_send(struct mei_cl *cl,
 		goto out;
 	}
 
+	if (vtag) {
+		/* Check if vtag is supported by client */
+		rets = mei_cl_vt_support_check(cl);
+		if (rets)
+			goto out;
+	}
+
 	if (length > mei_cl_mtu(cl)) {
 		rets = -EFBIG;
 		goto out;


