Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B115027A786
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 08:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725308AbgI1G0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 02:26:44 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:41764 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725290AbgI1G0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 02:26:44 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2020 02:26:44 EDT
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Sun, 27 Sep 2020 23:11:42 -0700
Received: from akaher-virtual-machine.eng.vmware.com (unknown [10.197.103.239])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 4CA3B24781;
        Sun, 27 Sep 2020 23:11:42 -0700 (PDT)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <b.zolnierkie@samsung.com>, <daniel.vetter@ffwll.ch>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <torvalds@linux-foundation.org>, <w@1wt.eu>,
        <yuanmingbuaa@gmail.com>, <srivatsab@vmware.com>,
        <srivatsa@csail.mit.edu>
Subject: [PATCH 4.4 20/46] fbcon: remove soft scrollback code
Date:   Mon, 28 Sep 2020 11:36:57 +0530
Message-ID: <1601273217-47349-1-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20200921162034.253730633@linuxfoundation.org>
References: <20200921162034.253730633@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> @@ -3378,7 +3054,6 @@ static const struct consw fb_con = {
>  	.con_font_default	= fbcon_set_def_font,
>  	.con_font_copy 		= fbcon_copy_font,
>  	.con_set_palette 	= fbcon_set_palette,
> -	.con_scrolldelta 	= fbcon_scrolldelta,
>  	.con_set_origin 	= fbcon_set_origin,
>  	.con_invert_region 	= fbcon_invert_region,
>  	.con_screen_pos 	= fbcon_screen_pos,

If I am not wrong, this change creates crash in v4.4.y.
As before calling con_scrolldelta, NULL check is missing inside
console_callback() for v4.4.y, refer:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/tty/vt/vt.c?h=linux-4.4.y#n2487

This NULL check was added in commit 97293de977365fe672daec2523e66ef457104921,
and this is not merged to v4.4.y

-Ajay
