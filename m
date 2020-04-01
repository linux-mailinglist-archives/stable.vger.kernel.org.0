Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1963E19B4DD
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 19:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732808AbgDARrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 13:47:20 -0400
Received: from mail-io1-f46.google.com ([209.85.166.46]:44763 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732211AbgDARrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 13:47:20 -0400
Received: by mail-io1-f46.google.com with SMTP id r25so550544ioc.11
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 10:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=79OCU2A1Y2j0hIjjbavaQYkVyv+GSu1qOE7wXpw9VLI=;
        b=ZpPqLCgppPGm8VOxp23hzQck/aSLhk7l37sWOHluLDV2ubLFIQ8dmKHMVaPvHN9pap
         NnhOnMu4Le7LLYP+7YA9KleJcRCxSSEq9zfhr+9A3USGXFMS+vHldqvnOYzM04Idednl
         HRjcQCaXfdz3UF9/2BjatWxUatRwC3d9IW6oVMRPm6wo5VTT2jUzj9UF/f/7cOTAnnLY
         w1DU/qDy6CNmVupabLs/71wNCUsjzqXopT8A71ArlyPNwCJk24de/IP4tVYtWngBlxcf
         1TTwU9Be5eULj8WAnW/S61IXIbbTY27qzMzxRxr0Nrv9dTmk3rYKH8II70JeIY346RKq
         lRag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=79OCU2A1Y2j0hIjjbavaQYkVyv+GSu1qOE7wXpw9VLI=;
        b=uV8A17nYYBYRZt8FkcXQwssUhl5ZTdqXOGdzxaLSSThV0DZY2RAUOIQvOGMc8DKCuY
         BDL72Is9vM1vz8oW89Vb+xpb7XRmeCoqzb7aeWo5Cmo/A1f7vJW9UnwYlcebbKmHPcop
         9VhxhyCgz74y3uRUGEmYJo9Gj/IBydyUsDCCoItGgCb1dx21EHXy0HTJ4uALS+qLwMi2
         yHNn0L4hG5koO6Zoff6wkmcA+DDUpPX/2DYRrJkRHfh37LFyfzdIOd6c2tgNMbTZhAI5
         +ML3TBt5CYzcMzhCU9pSZbJu4WbzIhh3cFinFCQcRLQZjBGIumjbWsikha3ktFsO/dA9
         HF5g==
X-Gm-Message-State: ANhLgQ0/GdqRJD3DAfSljrvUwqOby1Bqo1tM1GQ7A7fQuObFWyqKg2mT
        bSuzmHv4mHoGxlS/WQnthNwObQm7/6PzVDMhuAprKb5acBY=
X-Google-Smtp-Source: ADFU+vvCv6ic8MtqWa4rP+QVJg8t+HqCTFBQ3VspbhW92kTZ0srit4057gfX98XV2lg/4nONtLfrSxYZ1dsUdKWDcB0=
X-Received: by 2002:a05:6602:164b:: with SMTP id y11mr21663616iow.3.1585763239100;
 Wed, 01 Apr 2020 10:47:19 -0700 (PDT)
MIME-Version: 1.0
From:   Giuliano Procida <gprocida@google.com>
Date:   Wed, 1 Apr 2020 17:47:02 +0000
Message-ID: <CAGvU0HkVUE_mQY8AUjieRcRrD38gdJRE+CbDuenMxnU6DAFOSA@mail.gmail.com>
Subject: backport request for use-after-free blk_mq_queue_tag_busy_iter
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This issue was found in 4.14 and is present in earlier kernels.

Please backport

f5bbbbe4d635 blk-mq: sync the update nr_hw_queues with
blk_mq_queue_tag_busy_iter
530ca2c9bd69 blk-mq: Allow blocking queue tag iter callbacks

onto the stable branches that don't have these. The second is a fix
for the first. Thank you.

4.19.y and later - commits already present
4.14.y - f5bbbbe4d635 doesn't patch cleanly but it's still
straightforward, just drop the comment and code mentioning switching
to 'none' in the trailing context
4.9.y - ditto
4.4.y - there was a refactoring of the code in commit
0bf6cd5b9531bcc29c0a5e504b6ce2984c6fd8d8 making this non-trivial
3.16.y - ditto

I am happy to try to produce clean patches, but it may be a day or so.

Regards,
Giuliano.
