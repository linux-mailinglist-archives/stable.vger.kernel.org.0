Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 790332BB9C
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 23:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfE0VJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 17:09:36 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:52314 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfE0VJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 17:09:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hVMs9-0002DD-Qr; Mon, 27 May 2019 22:09:33 +0100
Message-ID: <1558991372.2631.10.camel@codethink.co.uk>
Subject: [stable] binder: fix race between munmap() and direct reclaim
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>
Cc:     stable <stable@vger.kernel.org>
Date:   Mon, 27 May 2019 22:09:32 +0100
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are commits in the 4.14, 4.19 and 5.0 stable branches that claim
to be backports of:

commit 26528be6720bb40bc8844e97ee73a37e530e9c5e
Author: Todd Kjos <tkjos@android.com>
Date:   Thu Feb 14 15:22:57 2019 -0800

    binder: fix handling of misaligned binder object

However the source changes actually match:

commit 5cec2d2e5839f9c0fec319c523a911e0a7fd299f
Author: Todd Kjos <tkjos@android.com>
Date:   Fri Mar 1 15:06:06 2019 -0800

    binder: fix race between munmap() and direct reclaim

So far as I can see, the former fixes a bug only introduced in 5.1 and
the latter fixes an older bug, so the changes are correct and only the
metadata is not.

Similar mix-ups have happened before and I'm a little disturbed that
this keeps happening.  In any case, you may want to revert and re-apply 
with correct metadata.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom
