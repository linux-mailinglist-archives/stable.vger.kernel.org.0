Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2380A1B405E
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgDVKph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:45:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:41066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729907AbgDVKpg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:45:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2C486ABD6;
        Wed, 22 Apr 2020 10:45:33 +0000 (UTC)
Subject: Re: [PATCH 5.6 096/166] x86/xen: Make the boot CPU idle task reliable
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Sasha Levin <sashal@kernel.org>
References: <20200422095047.669225321@linuxfoundation.org>
 <20200422095059.319186761@linuxfoundation.org>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <48afe770-83c3-03c0-c21f-334ab2056ea3@suse.com>
Date:   Wed, 22 Apr 2020 12:45:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200422095059.319186761@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22.04.20 11:57, Greg Kroah-Hartman wrote:
> From: Miroslav Benes <mbenes@suse.cz>
> 
> [ Upstream commit 2f62f36e62daec43aa7b9633ef7f18e042a80bed ]
> 
> The unwinder reports the boot CPU idle task's stack on XEN PV as
> unreliable, which affects at least live patching. There are two reasons
> for this. First, the task does not follow the x86 convention that its
> stack starts at the offset right below saved pt_regs. It allows the
> unwinder to easily detect the end of the stack and verify it. Second,
> startup_xen() function does not store the return address before jumping
> to xen_start_kernel() which confuses the unwinder.
> 
> Amend both issues by moving the starting point of initial stack in
> startup_xen() and storing the return address before the jump, which is
> exactly what call instruction does.
> 
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> Reviewed-by: Juergen Gross <jgross@suse.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

You'll need upstream d6f34f4c6b4a96 ("x86/xen: fix booting 32-bit pv
guest"), too.


Juergen
