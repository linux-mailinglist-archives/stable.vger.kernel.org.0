Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD53F33A4
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 16:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfKGPnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 10:43:46 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38986 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfKGPnq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Nov 2019 10:43:46 -0500
Received: by mail-qt1-f193.google.com with SMTP id t8so2851454qtc.6;
        Thu, 07 Nov 2019 07:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mwaiGtvP4pjM/nFFuK45HtDQzJ+7MTmhsD7fO3UNaLE=;
        b=rTdt1J+GEp1asFTQuPZVLcym1i5w0oDHdqK+9eXSBrJuj7tdWm6FUF8DlfmazZtYqO
         ghii+a6FoGSHFZg7Ys67K5plupUG3MZvxdDcnM61T2Z+XSu3/paB3f2akk4aCTK0cbRi
         7CWFxtSTtTLVzrgtNS9/g1A5TgCMrdM4OOEdsz4V5l7iS35AnyfsaQBFFo4lnnnP6UYu
         0j+GZmDCRxHFSj7hYHPU6DydmhEF6Yo72kZruft0BxB/Xl2jgVur26PTpGZ/8OdK1nAI
         9koLUWef6/HPzFUSIEKrgh46voUNO8YEWWCvNlAZxxVvyvE5IZDvc9t+F1VACtj4fj9e
         8rPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mwaiGtvP4pjM/nFFuK45HtDQzJ+7MTmhsD7fO3UNaLE=;
        b=MMqKn7+ALEfY4HBsxk0mJ89UUYOadPQbBcXoMzxhhVHErKu7qLJtF7K7YOX0wj1Dnz
         sf90s5cyZh1F37JgtOWjEFqSgv+tLXdiZHi6AGRfaLVrBKkVyN1E0sj/z10Zfk1bx/R0
         AmnThrOuLmJhF70mhs2vq0Z0187Gl2uky5vW7mGspcrmtBqxJhfnUzwkX4Pv/g56NoS9
         jZJlMDRN2k4ye5Z8r98dS7WHZ+tg7RMsDT0l9ZTaZOUOQBVWshKaK6DwMcl5rp94q97L
         2TR43ifUeQ/F0F7M2Ex5ffKig3XGUty7Cp0JlJ7TaDORyYyW2bie0yOhxsjngJQPBNG4
         W9lg==
X-Gm-Message-State: APjAAAVRi91zwiLr52azi7qk+51S6OkVM1mzFWQPx9Uyo43oeQDsY+f9
        j+M00CphfrXQji0nSnY26AI=
X-Google-Smtp-Source: APXvYqwJ9bgJnSqOfuwT4NQVIu7t7ruriREekPrkgTiHagbiyhpNcODVa5lJPsXIvI+5oxoMsisDwg==
X-Received: by 2002:ac8:3a21:: with SMTP id w30mr4498647qte.299.1573141424023;
        Thu, 07 Nov 2019 07:43:44 -0800 (PST)
Received: from localhost ([2620:10d:c091:500::2:3f13])
        by smtp.gmail.com with ESMTPSA id f24sm1147320qkh.81.2019.11.07.07.43.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 07:43:43 -0800 (PST)
Date:   Thu, 7 Nov 2019 07:43:41 -0800
From:   Tejun Heo <tj@kernel.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Roman Gushchin <guro@fb.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Message-ID: <20191107154341.GX3622521@devbig004.ftw2.facebook.com>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191107122125.GS8314@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107122125.GS8314@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Thu, Nov 07, 2019 at 01:21:25PM +0100, Michal Hocko wrote:
> Hmm, how can we have a task in an offline memcg? I thought that any
> existing task will prevent cgroup removal from proceeding. Is this some
> sort of race where the task managed to disassociate from the cgroup
> while there is still a binding to a memcg existing? What am I missing?

The previous cgroup one was from bsd process accounting which happens
after the process is marked head.  This one IIUC is from core dumping
path.

Thanks.

-- 
tejun
