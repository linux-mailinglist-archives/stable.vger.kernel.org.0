Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50CEA1C0A72
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 00:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgD3WfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 18:35:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbgD3WfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 18:35:00 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BE1820731;
        Thu, 30 Apr 2020 22:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588286099;
        bh=M3JxNsWKgExkI8i1lNZFsxBk05w+tX6N63RVAkYOjCM=;
        h=Date:From:To:Cc:Subject:From;
        b=BnnXkFS0fLFhaPXHl4P5E3UVsVmUtR07WwGxJBqhz5d3OPjd4ZyJYBFYlX4EjcdFJ
         PGk7o14wzeHcmcErTQ3jvNuGCW8ufrhUP3Vz6FA9RYUko6hzrlfGErj1Y+8uAgLfQk
         L7jqy7HqrsWmYDHNsK7DppD93TW3Pq9u2Q+FbDJA=
Date:   Thu, 30 Apr 2020 18:34:58 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, runderwood@linkedin.com
Subject: ext4 perf regression on LTS kernels
Message-ID: <20200430223458.GY13035@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi folks,

We're working on trying to figure out a severe performance regression in
the 5.4 and older LTS trees. The regression seems to happen only on
physical spinning rust disks, which is why it was probably went
unnoticed.

The regression seems to be introduced in v4.7 with:

        1f60fbe72749 ("ext4: allow readdir()'s of large empty directories to be interrupted")

The fio test used to reproduce it is:

	sync; i=0; while [ $i -lt 4 ]; do ( ( time fio
	--name=disk-burner --readwrite=write --bs=4096 --invalidate=1
	--end_fsync=0 --filesize=800M --runtime=120 --ioengine=libaio
	--thread --numjobs=20 --iodepth=1 --unlink=1 ) 2>&1 | grep
	'^real' ); ((i++)); done

When run with the offending commit, it'll take 3-4x longer to complete.

The regression was fixed upstream somewhere in this merge:

        e5da4c933c50 ("Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4")

but it seems to be a combination of commits that fix it rather than a
single one.

Now, here's the tricky part... reverting these two commits on top of
v4.19.118 "fixes" the issue:

        06bd3c36a733 ("ext4: fix data exposure after a crash")
        1f60fbe72749 ("ext4: allow readdir()'s of large empty directories to be interrupted")

but clearly this is not something we want to do in the stable trees, so
we're trying to figure out the proper way to fix this.

-- 
Thanks,
Sasha
