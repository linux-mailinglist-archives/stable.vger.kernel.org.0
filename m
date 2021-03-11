Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A3F33718E
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 12:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhCKLjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 06:39:49 -0500
Received: from verein.lst.de ([213.95.11.211]:40583 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232782AbhCKLjm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 06:39:42 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 58DDE68B05; Thu, 11 Mar 2021 12:39:40 +0100 (CET)
Date:   Thu, 11 Mar 2021 12:39:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     gregkh@linuxfoundation.org
Cc:     Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] configfs: Fix config_item refcnt error in
 __configfs_open_file()
Message-ID: <20210311113940.GA17668@lst.de>
References: <20210311113510.1031406-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311113510.1031406-1-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 11, 2021 at 12:35:10PM +0100, gregkh@linuxfoundation.org wrote:
> From: Daniel Rosenberg <drosen@google.com>
> 
> __configfs_open_file() used to use configfs_get_config_item, but changed
> in commit b0841eefd969 ("configfs: provide exclusion between IO and
> removals") to just call to_item. The error path still tries to clean up
> the reference, incorrectly decrementing the ref count.

This should already be covered by:

http://git.infradead.org/users/hch/configfs.git/commitdiff/14fbbc8297728e880070f7b077b3301a8c698ef9
