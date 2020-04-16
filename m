Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A601ACE14
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 18:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbgDPQyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 12:54:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:5652 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729249AbgDPQyh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 12:54:37 -0400
IronPort-SDR: +nM7DDdPijNq33yBRHc9Ar+6wB4EO+DgwN2VuQxEpqABKy8UtjMtu3pmIcl0D9YljzXTj43nYs
 BbcWm/2ejqPA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 09:54:36 -0700
IronPort-SDR: LIqcIv3CFFA2Is1/UUXsyl7xUaROGbP/LPzZZCmEIUmexkP5i6kC2b6GorkhFzoL8ZkYj3mbWZ
 LNciuRFa5+5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,391,1580803200"; 
   d="scan'208";a="454399034"
Received: from otazetdi-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.42.128])
  by fmsmga005.fm.intel.com with ESMTP; 16 Apr 2020 09:54:33 -0700
Date:   Thu, 16 Apr 2020 19:54:32 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     David Howells <dhowells@redhat.com>
Cc:     torvalds@linux-foundation.org, stable@vger.kernel.org,
        Vasily Averin <vvs@virtuozzo.com>, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] keys: Fix proc_keys_next to increase position index
Message-ID: <20200416165432.GA199110@linux.intel.com>
References: <158689639664.3925765.4549426529245164675.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158689639664.3925765.4549426529245164675.stgit@warthog.procyon.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 09:33:16PM +0100, David Howells wrote:
> From: Vasily Averin <vvs@virtuozzo.com>
> 
> If seq_file .next function does not change position index,
> read after some lseek can generate unexpected output:
> 
> $ dd if=/proc/keys bs=1  # full usual output
> 0f6bfdf5 I--Q---     2 perm 3f010000  1000  1000 user      4af2f79ab8848d0a: 740
> 1fb91b32 I--Q---     3 perm 1f3f0000  1000 65534 keyring   _uid.1000: 2
> 27589480 I--Q---     1 perm 0b0b0000     0     0 user      invocation_id: 16
> 2f33ab67 I--Q---   152 perm 3f030000     0     0 keyring   _ses: 2
> 33f1d8fa I--Q---     4 perm 3f030000  1000  1000 keyring   _ses: 1
> 3d427fda I--Q---     2 perm 3f010000  1000  1000 user      69ec44aec7678e5a: 740
> 3ead4096 I--Q---     1 perm 1f3f0000  1000 65534 keyring   _uid_ses.1000: 1
> 521+0 records in
> 521+0 records out
> 521 bytes copied, 0,00123769 s, 421 kB/s
> 
> $ dd if=/proc/keys bs=500 skip=1  # read after lseek in middle of last line
> dd: /proc/keys: cannot skip to specified offset
> g   _uid_ses.1000: 1        <<<< end of last line
> 3ead4096 I--Q---     1 perm 1f3f0000  1000 65534 keyring   _uid_ses.1000: 1
>    <<<< and whole last line again
> 0+1 records in
> 0+1 records out
> 97 bytes copied, 0,000135035 s, 718 kB/s
> 
> $ dd if=/proc/keys bs=1000 skip=1   # read after lseek beyond end of file
> dd: /proc/keys: cannot skip to specified offset
> 3ead4096 I--Q---     1 perm 1f3f0000  1000 65534 keyring   _uid_ses.1000: 1
>    <<<< generates last line
> 0+1 records in
> 0+1 records out
> 76 bytes copied, 0,000119981 s, 633 kB/s
> 
> See https://bugzilla.kernel.org/show_bug.cgi?id=206283
> 
> Cc: stable@vger.kernel.org

# 4.19.x

> Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
