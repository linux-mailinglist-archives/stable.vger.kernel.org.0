Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A6F50296D
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 14:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244633AbiDOMN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 08:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353166AbiDOMNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 08:13:25 -0400
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69E5BF518
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 05:10:49 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5ddd7616.dip0.t-ipconnect.de [93.221.118.22])
        by mail.itouring.de (Postfix) with ESMTPSA id 0F87B124EC0;
        Fri, 15 Apr 2022 14:10:47 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id B5E52F01608;
        Fri, 15 Apr 2022 14:10:46 +0200 (CEST)
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: 5.15 request: properly backport VFS/XFS syncfs error handling
Organization: Applied Asynchrony, Inc.
Message-ID: <8997252f-0196-97aa-659e-34524b7b3593@applied-asynchrony.com>
Date:   Fri, 15 Apr 2022 14:10:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


I noticed that our autobot recently backported parts of a series which
fixed XFS syncfs error handling [1]. Unfortunately - due to missing
requirements - it only managed to merge those patches which do not
actually fix anything.

This can be repaired by applying the prerequisites and then the missing
parts of the original series, namely in order:

   9a208ba5c9af fs: remove __sync_filesystem
   70164eb6ccb7 block: remove __sync_blockdev
   1e03a36bdff4 block: simplify the block device syncing code
   5679897eb104 vfs: make sync_filesystem return errors from ->sync_fs
   2d86293c7075 xfs: return errors in xfs_fs_sync_fs

With all that we could also put a cherry on top and merge:

   b97cca3ba909 xfs: only bother with sync_filesystem during readonly remount

but that's just a touchup and not a real bugfix, so probably optional.

thanks,
Holger

[1] https://lore.kernel.org/linux-xfs/164316348940.2600168.17153575889519271710.stgit@magnolia/
